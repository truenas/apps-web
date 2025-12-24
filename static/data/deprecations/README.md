# Per-App Deprecation Tracking

This directory contains per-app deprecation files that mirror the `deprecations.yaml` files from the apps repository.

## Structure

Each app with deprecation information gets its own file:
- `codegate.yaml` - mirrors `/trains/community/codegate/deprecations.yaml`
- `readarr.yaml` - mirrors `/trains/stable/readarr/deprecations.yaml`
- etc.

## Format

Each file contains the deprecation metadata for that specific app:

```yaml
status: deprecated
train: community
deprecated_date: "2025-09-01"
removal_date: "2025-10-03"
reason: "No longer maintained by upstream"
scope: full_app  # or partial
alternative_app: "code-server"
migration_guide: "https://www.truenas.com/docs/..."

# For partial deprecations only
partial_details:
  feature: "PostgreSQL 13 images"
  description: "Details..."
  steps:
    - "Step 1"
    - "Step 2"
```

## Automation

The `generate_app_files.sh` script:
1. Checks for `deprecations.yaml` in each app's directory in `Apps_Temp/trains/[train]/[app]/`
2. Copies it to this directory as `[app].yaml`
3. Uses this data to generate deprecation warnings on app pages

## Note

This directory will be populated automatically when:
1. The apps repo middleware supports `deprecations.yaml` validation
2. App maintainers add `deprecations.yaml` to their apps
3. The generation script is updated to copy these files

Until then, files can be manually added here for testing or to handle known deprecations.
