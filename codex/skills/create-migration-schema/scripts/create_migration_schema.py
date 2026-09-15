#!/usr/bin/env python3
"""Create a numbered Drizzle SQL migration and append its journal entry."""

from __future__ import annotations

import argparse
import json
import re
import sys
import time
from pathlib import Path


def find_repo_root(start: Path) -> Path:
    for path in [start, *start.parents]:
        if (path / "apps/api/drizzle").is_dir():
            return path
    raise SystemExit("Could not find repo root containing apps/api/drizzle.")


def normalize_scope(scope: str) -> str:
    value = scope.strip().lower()
    if value in {"global", "core"}:
        return "global"
    if value == "tenant":
        return "tenant"
    raise SystemExit("Scope must be one of: global, core, tenant.")


def slugify(value: str) -> str:
    slug = re.sub(r"[^a-z0-9]+", "_", value.lower()).strip("_")
    slug = re.sub(r"_+", "_", slug)
    if not slug:
        raise SystemExit("Migration name must contain at least one letter or number.")
    return slug


def next_migration_number(migrations_dir: Path) -> int:
    highest = -1
    for path in migrations_dir.glob("*.sql"):
        match = re.match(r"^(\d{4})_", path.name)
        if match:
            highest = max(highest, int(match.group(1)))
    return highest + 1


def load_journal(journal_path: Path) -> dict:
    if not journal_path.exists():
        return {"version": "7", "dialect": "postgresql", "entries": []}
    with journal_path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def write_journal(journal_path: Path, journal: dict) -> None:
    journal_path.parent.mkdir(parents=True, exist_ok=True)
    with journal_path.open("w", encoding="utf-8") as handle:
        json.dump(journal, handle, indent=2)
        handle.write("\n")


def read_sql(args: argparse.Namespace, tag: str) -> str:
    if args.sql_file:
        return Path(args.sql_file).read_text(encoding="utf-8")
    if args.sql is not None:
        return args.sql
    return f'-- TODO: Write migration SQL for "{tag}".\n'


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Create a Drizzle migration SQL file and update _journal.json.",
    )
    parser.add_argument(
        "--scope",
        required=True,
        help="Migration scope: global/core for apps/api/drizzle, or tenant.",
    )
    parser.add_argument("--name", required=True, help="Short migration name.")
    parser.add_argument("--sql", help="SQL content to write into the migration file.")
    parser.add_argument("--sql-file", help="Read SQL content from this file.")
    parser.add_argument(
        "--repo-root",
        help="Repo root. Defaults to walking upward from the current directory.",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Overwrite the SQL file if it already exists. Journal duplicates still fail.",
    )
    args = parser.parse_args()

    scope = normalize_scope(args.scope)
    repo_root = Path(args.repo_root).resolve() if args.repo_root else find_repo_root(Path.cwd())
    migrations_dir = repo_root / "apps/api/drizzle"
    if scope == "tenant":
        migrations_dir = migrations_dir / "tenant"

    journal_path = migrations_dir / "meta/_journal.json"
    number = next_migration_number(migrations_dir)
    tag = f"{number:04d}_{slugify(args.name)}"
    migration_path = migrations_dir / f"{tag}.sql"

    if migration_path.exists() and not args.force:
        raise SystemExit(f"Migration already exists: {migration_path}")

    journal = load_journal(journal_path)
    entries = journal.setdefault("entries", [])
    if any(entry.get("tag") == tag for entry in entries):
        raise SystemExit(f"Journal already contains tag: {tag}")

    migrations_dir.mkdir(parents=True, exist_ok=True)
    migration_path.write_text(read_sql(args, tag), encoding="utf-8")

    next_idx = max((int(entry.get("idx", -1)) for entry in entries), default=-1) + 1
    entries.append(
        {
            "idx": next_idx,
            "version": str(journal.get("version", "7")),
            "when": int(time.time() * 1000),
            "tag": tag,
            "breakpoints": True,
        },
    )
    write_journal(journal_path, journal)

    print(f"created {migration_path}")
    print(f"updated {journal_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
