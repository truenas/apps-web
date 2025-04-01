# apps-web

This repository contains all the raw files for building the TrueNAS Apps website.

The strategy for this site is to be as automated as possible.
Home page, catalog, and app details pages are populated with content automatically.
Content is ingested from the metadata for individual apps and is thus kept consistent with the day-to-day changes in the TrueNAS project, provided the site is refreshed regularly.
We also incorporate the publicly available anonymous telemetry for TrueNAS apps, as part of measuring active use.
New markdown files for app details are automatically generated from a comparison check with the primary TrueNAS apps repository: https://www.github.com/truenas/apps (WIP)

Static content like deployment articles follows a diataxis approach, with autopopulated catalog entries functioning as landing pages and static articles filed under "Resources" subheader for each app.
Shortcodes are used to single-source common messages that apply to many content locations.

This repository accepts contributions!
The content/resources/ location holds all articles that aren't auto-generated from app metadata.
Contributors can propose a new file to this location.
The file needs to follow a consistent front matter layout for better integration with the site.
A pointer to the file also needs to be added to the related catalog entry for that particular app.
Images can be proposed to the static/images/ directory.

Browse through the content/ and static/ locations for numerous examples of how to create and link articles to app details pages.
Entries in the content/Stable-Apps/ location provide the most complete examples.

To modify a content/resources/ article that already exists directly from the published website, look for the **Edit page** button in the upper right corner of the article.
Some articles related to Enterprise apps might not have this element, as this content tends to be directly maintained by the TrueNAS team.
