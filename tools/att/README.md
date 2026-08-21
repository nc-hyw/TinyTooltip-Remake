# All The Things database input

`update_att_db.py` downloads the Retail source database from an official All The Things release into the repository's `db_att` directory. It requires Python 3.10 or newer and uses only the Python standard library.

Use the latest official release:

```powershell
python3 tools/att/update_att_db.py
```

Use an exact release tag:

```powershell
python3 tools/att/update_att_db.py --release 5.3.0a
```

The script extracts `db/Standard` from the tagged ATT source archive, copies ATT's license, and writes `db_att/UPSTREAM.json` with the exact release and commit. It replaces the previous `db_att` snapshot after the new download has been validated.

`db_att` is an ignored build cache. Normalized TinyTooltip data will be generated separately under `db`.
