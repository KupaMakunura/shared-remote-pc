---
name: create-migration-schema
description: Use when creating a new Drizzle SQL migration in this TMS-style repo. Creates the next numbered migration SQL file and updates the correct meta/_journal.json entry for either global/core migrations or tenant-specific migrations.
metadata:
  short-description: Create SQL migration plus journal entry
---

# Create Migration Schema

Use this skill when the user asks to create a migration file, schema SQL file,
or journal entry for this repo's Drizzle migrations.

## Workflow

1. Decide migration scope:
   - `global` / `core`: `apps/api/drizzle`
   - `tenant`: `apps/api/drizzle/tenant`
2. Prefer the bundled script instead of hand-editing the journal:

```bash
python3 /home/kupa/.codex/skills/create-migration-schema/scripts/create_migration_schema.py --scope global --name example_name
python3 /home/kupa/.codex/skills/create-migration-schema/scripts/create_migration_schema.py --scope tenant --name example_name
```

3. Put the migration SQL in the created file. You can pass SQL at creation time:

```bash
python3 /home/kupa/.codex/skills/create-migration-schema/scripts/create_migration_schema.py \
  --scope global \
  --name report_recipients \
  --sql 'CREATE TABLE IF NOT EXISTS "report_recipients" (...);'
```

4. Verify:
   - The next available `NNNN_slug.sql` was created in the selected directory.
   - The selected `meta/_journal.json` contains a new entry with the same tag.
   - Do not update tenant journal for global migrations, or global journal for tenant migrations.

## Rules

- Never skip the journal update.
- Never reuse an existing migration number.
- Keep tags lowercase snake_case: `NNNN_short_slug`.
- If the user says only "schema" or "migration" and the target table lives in
  core schema files under `apps/api/src/db/schema/core`, use `global`.
- If the target table lives under tenant tables or is per-client data, use `tenant`.
- If scope is ambiguous and code context cannot resolve it, ask one concise question.
