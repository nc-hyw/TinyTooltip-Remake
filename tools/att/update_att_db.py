#!/usr/bin/env python3
"""Download the Retail All The Things source database into db_att."""

from __future__ import annotations

import argparse
import json
import os
import shutil
import sys
import tarfile
import tempfile
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path, PurePosixPath
from typing import Any


ATT_REPOSITORY = "ATTWoWAddon/AllTheThings"
ATT_API = f"https://api.github.com/repos/{ATT_REPOSITORY}"
ATT_SOURCE_DIRECTORY = ("db", "Standard")
REQUIRED_DATABASE_FILES = (
    "Database.xml",
    "LocalizationDB.lua",
    "ReferenceDB.lua",
    "Categories/Craftables.lua",
    "Categories/Instances.lua",
    "Categories/Professions.lua",
    "Categories/WorldDrops.lua",
    "Categories/Zones.lua",
)

PROJECT_ROOT = Path(__file__).resolve().parents[2]
OUTPUT_DIRECTORY = PROJECT_ROOT / "db_att"


class UpdateError(RuntimeError):
    """An expected database update failure."""


def github_headers() -> dict[str, str]:
    headers = {
        "Accept": "application/vnd.github+json",
        "User-Agent": "TinyTooltip-Remake-ATT-Updater",
        "X-GitHub-Api-Version": "2022-11-28",
    }
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        headers["Authorization"] = f"Bearer {token}"
    return headers


def request_json(url: str) -> dict[str, Any]:
    request = urllib.request.Request(url, headers=github_headers())
    try:
        with urllib.request.urlopen(request, timeout=60) as response:
            return json.load(response)
    except (urllib.error.HTTPError, urllib.error.URLError, TimeoutError) as error:
        raise UpdateError(f"GitHub request failed: {url}\n{error}") from error


def get_release(release_tag: str | None) -> dict[str, Any]:
    if release_tag:
        encoded_tag = urllib.parse.quote(release_tag, safe="")
        release = request_json(f"{ATT_API}/releases/tags/{encoded_tag}")
    else:
        release = request_json(f"{ATT_API}/releases/latest")

    if release.get("draft") or release.get("prerelease"):
        raise UpdateError("The selected ATT release is not an official published release.")
    if not release.get("tag_name") or not release.get("tarball_url"):
        raise UpdateError("The ATT release response is missing its tag or tarball URL.")
    return release


def get_tag_commit(tag_name: str) -> str:
    encoded_tag = urllib.parse.quote(tag_name, safe="")
    reference = request_json(f"{ATT_API}/git/ref/tags/{encoded_tag}")
    git_object = reference.get("object")

    while isinstance(git_object, dict) and git_object.get("type") == "tag":
        tag_sha = git_object.get("sha")
        if not tag_sha:
            raise UpdateError(f"ATT tag {tag_name!r} has no Git object SHA.")
        tag = request_json(f"{ATT_API}/git/tags/{tag_sha}")
        git_object = tag.get("object")

    if not isinstance(git_object, dict) or git_object.get("type") != "commit":
        raise UpdateError(f"ATT tag {tag_name!r} does not resolve to a commit.")

    commit = git_object.get("sha")
    if not isinstance(commit, str) or len(commit) != 40:
        raise UpdateError(f"ATT tag {tag_name!r} returned an invalid commit SHA.")
    return commit


def download_tarball(url: str, destination: Path) -> None:
    request = urllib.request.Request(url, headers=github_headers())
    try:
        with urllib.request.urlopen(request, timeout=120) as response:
            with destination.open("wb") as archive_file:
                shutil.copyfileobj(response, archive_file)
    except (urllib.error.HTTPError, urllib.error.URLError, TimeoutError) as error:
        raise UpdateError(f"ATT archive download failed: {url}\n{error}") from error


def extract_database(archive_path: Path, destination: Path) -> None:
    database_files = 0
    license_found = False

    try:
        archive = tarfile.open(archive_path, mode="r:gz")
    except (tarfile.TarError, OSError) as error:
        raise UpdateError(f"The downloaded ATT archive is invalid: {error}") from error

    with archive:
        for member in archive.getmembers():
            parts = PurePosixPath(member.name).parts
            relative_parts: tuple[str, ...] | None = None

            if len(parts) >= 4 and parts[1:3] == ATT_SOURCE_DIRECTORY:
                relative_parts = parts[3:]
            elif len(parts) == 2 and parts[1] == "LICENSE":
                relative_parts = ("LICENSE",)
                license_found = True
            else:
                continue

            if member.isdir():
                destination.joinpath(*relative_parts).mkdir(parents=True, exist_ok=True)
                continue
            if not member.isfile():
                raise UpdateError(f"Unsupported link or special file in ATT archive: {member.name}")

            target = destination.joinpath(*relative_parts)
            target.parent.mkdir(parents=True, exist_ok=True)
            source = archive.extractfile(member)
            if source is None:
                raise UpdateError(f"Could not read ATT archive member: {member.name}")
            with source, target.open("wb") as output_file:
                shutil.copyfileobj(source, output_file)

            if relative_parts != ("LICENSE",):
                database_files += 1

    if database_files == 0:
        raise UpdateError("The ATT archive did not contain db/Standard.")
    if not license_found:
        raise UpdateError("The ATT archive did not contain its LICENSE file.")

    missing = [name for name in REQUIRED_DATABASE_FILES if not (destination / name).is_file()]
    if missing:
        formatted = "\n".join(f"  - {name}" for name in missing)
        raise UpdateError(f"The ATT Retail database layout changed; required files are missing:\n{formatted}")


def read_current_commit() -> str | None:
    metadata_path = OUTPUT_DIRECTORY / "UPSTREAM.json"
    if not metadata_path.is_file():
        return None
    try:
        metadata = json.loads(metadata_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return None
    commit = metadata.get("commit")
    return commit if isinstance(commit, str) else None


def replace_output(staged_database: Path) -> None:
    output_resolved = OUTPUT_DIRECTORY.resolve()
    project_resolved = PROJECT_ROOT.resolve()
    if output_resolved.parent != project_resolved or output_resolved.name != "db_att":
        raise UpdateError(f"Refusing to replace unexpected output directory: {output_resolved}")

    backup = PROJECT_ROOT / ".db_att.backup"
    if backup.exists():
        raise UpdateError(f"A previous update backup still exists: {backup}")

    if OUTPUT_DIRECTORY.exists():
        OUTPUT_DIRECTORY.rename(backup)

    try:
        staged_database.rename(OUTPUT_DIRECTORY)
    except Exception:
        if backup.exists() and not OUTPUT_DIRECTORY.exists():
            backup.rename(OUTPUT_DIRECTORY)
        raise
    else:
        if backup.exists():
            shutil.rmtree(backup)


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Download an official All The Things release and replace db_att with "
            "its Retail source database (db/Standard)."
        )
    )
    parser.add_argument(
        "--release",
        metavar="TAG",
        help="ATT release tag to download; defaults to the latest official release",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="download again even when db_att already records the same ATT commit",
    )
    return parser.parse_args()


def main() -> int:
    arguments = parse_arguments()

    try:
        release = get_release(arguments.release)
        tag_name = str(release["tag_name"])
        commit = get_tag_commit(tag_name)

        if not arguments.force and read_current_commit() == commit:
            print(f"db_att is already current: ATT {tag_name} ({commit})")
            return 0

        with tempfile.TemporaryDirectory(prefix="tinytooltip-att-", dir=PROJECT_ROOT) as temporary:
            temporary_path = Path(temporary)
            archive_path = temporary_path / "att.tar.gz"
            staged_database = temporary_path / "db_att"
            staged_database.mkdir()

            print(f"Downloading ATT {tag_name} ({commit})...")
            download_tarball(str(release["tarball_url"]), archive_path)
            extract_database(archive_path, staged_database)

            metadata = {
                "schema": 1,
                "repository": ATT_REPOSITORY,
                "release": tag_name,
                "commit": commit,
                "published_at": release.get("published_at"),
                "source_directory": "/".join(ATT_SOURCE_DIRECTORY),
            }
            (staged_database / "UPSTREAM.json").write_text(
                json.dumps(metadata, indent=2, sort_keys=True) + "\n",
                encoding="utf-8",
                newline="\n",
            )

            replace_output(staged_database)

        file_count = sum(1 for path in OUTPUT_DIRECTORY.rglob("*") if path.is_file())
        print(f"Updated {OUTPUT_DIRECTORY} with {file_count} files from ATT {tag_name}.")
        return 0
    except UpdateError as error:
        print(f"error: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
