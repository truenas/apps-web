---
title: "App Storage"
description: "Information about the different types of storage volumes used for TrueNAS Apps: the ix-apps dataset, ixVolume datasets, host path datasets, SMB share volumes, and Tmpfs. "
GeekdocShowEdit: false
doctype: foundations
tags:
- apps
keywords:
- truenas app storage
- truenas ix-apps dataset
- container storage truenas
- persistent storage truenas apps
- host path truenas configuration
- docker volumes truenas
- truenas app data management
---

{{< getting-started-return-button >}}

Applications in TrueNAS make use of a variety of dataset types for app storage.

The **ix-apps** dataset is the base-level storage volume for app data.
Additionally, configuration options for individual apps include one or more of the following storage types: ixVolume datasets, host path datasets, SMB share volumes, and Tmpfs.
Each dataset type has unique characteristics and considerations.

If an application requires specific host path datasets, create the datasets before installing the application.
For example, the [Nextcloud](/catalog/nextcloud) app requires three datasets: **html** for app data, **data** for user data, and **postgres_data** for the database data storage volume.
[Create these datasets](https://www.truenas.com/docs/scale/25.10/scaletutorials/datasets/datasetsscale/) before installing the app.
See individual app information screens and app tutorials for more information.

{{< include file="/static/includes/apps/AppsDatasets.md" >}}

## Next Steps

{{< include file="/static/includes/getting-started-next-steps.md" >}}
