---
title: "Mealie Deployment Notes"
description: "Provides installation instructions for the Mealie application in TrueNAS."
related_app: "/catalog/mealie"
GeekdocShowEdit: true
geekdocEditPath: "edit/main/content/resources/deploy-mealie.md"
tags:
- apps
---

{{< resource-return-button >}}

{{< include file="/static/includes/apps/CommunityApp.md" >}}

{{< include file="/static/includes/ProposeArticleChange.md" >}}

[Mealie](https://docs.mealie.io) is a self-hosted recipe manager and meal planner.

## Configuration

### Mealie Configuration

- **Base URL**: Set to the NAS URL, and append `:` and the **Web Port** set in the **Network Configuration** section (probably `31001`).
  E.g., if your NAS is `https://10.10.0.1` and the web port is `31001` then this is `https://10.10.0.1:31001`.
- Default Admin Email: E-mail address to use for Mealie admin (e.g., your e-mail address).
- Default Admin Password: Password to use for admin user.

### User and Group Configuration

- **User ID**: Set to `911` to match the default described in https://docs.mealie.io/documentation/getting-started/installation/backend-config/.
- **Group ID**: Set to `911` to match the default described in https://docs.mealie.io/documentation/getting-started/installation/backend-config/.
