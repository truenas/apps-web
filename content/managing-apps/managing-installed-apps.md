---
title: "Managing Installed Apps"
description: "Provides information on managing apps in TrueNAS including updating, deleting, stopping and starting, and managing container images."
GeekdocShowEdit: true
geekdocEditPath: "edit/main/content/managing-apps/managing-installed-apps.md"
doctype: tutorial
tags:
- apps
keywords:
  - TrueNAS app management
  - updating TrueNAS apps
  - deleting TrueNAS apps
  - managing Docker apps
  - container image management
  - app installation tutorial
  - TrueNAS workloads management
---

{{< managing-apps-return-button >}}

This article covers administering installed applications in TrueNAS.
For details on how to set up app storage, configure global settings, and prepare TrueNAS to deploy applications, see [Initial Setup](/getting-started/initial-setup).
For installing applications from the catalog, see [Installing Apps](/managing-apps/installing-apps).
For custom applications, see [Installing Custom Apps](/managing-apps/installing-custom-apps).

Installed applications appear on the **Installed** applications screen.
Click on an app row to view **Details**, including the **Application Info**, **Workloads**, **Notes**, and **Application Metadata** widgets.

{{< trueimage src="/images/Apps/InstalledAppsScreenWithApps.png" alt="Installed Applications Screen" id="Installed Applications Screen" >}}

## Editing Apps

From the **Application Info** widget, click **Edit** to edit app configuration settings.

In the **Edit** screen, users can change all initial configuration settings apart from application name and type of storage volume.

After making all desired configuration changes, click **Update** and the bottom of the **Edit** screen to save all modifications. Changes are applied automatically after you have updated the app configuration.

## Updating Apps

Apps with available updates show a yellow circle with an exclamation point on the right side of the **Applications** table row, and the **Installed** application screen banner displays an **Update** or an **Update All** button.
To update an app, select the app row and click <i class="material-icons" aria-hidden="true" title="more_vert">more_vert</i> on the **Application Info** widget, then select **Update** from the dropdown menu.
To update multiple apps, either click the **Update All** button on the **Installed** applications banner or select the checkbox to the left of the application row to show the **Bulk Actions** button.
Click **Bulk Actions** and select **Update All** to update the apps selected.
Update options only show if TrueNAS detects an available update for installed applications.

**Update** opens an update window that includes two selectable options, **Images (to be updated)** and **Changelog**.
Click on the down arrow to see the options available for each.

{{< trueimage src="/images/Apps/AppUpdateWindow.png" alt="Update Application Window" id="Update Application Window" >}}

Click **Update** to begin the process. A counter dialog opens showing the update progress.
When complete, the update badge and buttons disappear and the application **Update** state on the **Installed** screen changes from **Update Available** to **Up to date**.

### Rolling Back to Previous Versions

To roll back an application to a previous version, select the app you wish to roll back from the **Installed** applications screen.
This opens the **Application Info** widget on the right side of the screen and provides users with the **Roll Back** button.

{{< trueimage src="/images/apps/RollBackDialog.png" alt="Roll Back Dialog" id="Roll Back Dialog" >}}

The **Version** dropdown contains available app versions for roll back.
The version numbers displayed are the version of the app in the TrueNAS catalog, equivalent to the **Version** displayed on the app information card.
It is not equal to the **App Version** or the upstream release version.
See [Understanding Versions](https://apps.truenas.com/managing-apps/discovering-apps/#understanding-versions) for more information.


Click **Roll back snapshots** to restore the application data volume to match the selected version by rolling back to the snapshot for that version.
This reverts both the application and app data stored in the apps pool to the exact state from when the snapshot was created.

{{< hint type=note >}}
**Roll back snapshots** only affects data saved in the apps dataset, such as iXvolume storage.
Data in mounted host paths is not rolled back.
{{< /hint >}}

Click **Roll Back** to begin the operation.

## Migrating Existing Applications

{{< include file="/static/includes/apps/MigrateExisting.md" >}}

## Deleting Apps

To delete an application, click <i class="fa fa-stop" aria-hidden="true"></i> **Stop** on the application row.
After the app status changes to stopped, click **Delete** on the **Application Info** widget for the selected application to open the **Delete App** dialog.

{{< trueimage src="/images/Apps/AppsDeleteAppDialog.png" alt="Delete Application Dialog" id="Delete Application Dialog" >}}

Select **Remove iXVolumes** to delete hidden app storage from the apps pool.
Select **Force-Remove iXVolumes** to delete app storage created on TrueNAS 24.04 and migrated to 24.10 or later.
Proceed with caution as this option removes both legacy Kubernetes and current Docker data for the application.

Select **Remove Images** to prune Docker images of the deleted app.

Click **Confirm** then **Continue** to delete the application.

## Stopping Apps

Apps on the **Installed** screen, showing either the **Deploying** or **Running** status, can be stopped using the stop button on the **Applications** table row for the app.

## Restarting Apps

Running apps show the restart icon button that allows you to stop and then restart the application.
Click the <span class="material-icons">restart_alt</span> icon button to stop then automatically restart the app.

## Viewing Workloads

The **Workloads** widget shows ports and container information.
Each container includes buttons to access a container shell, view volume mounts, and view logs.

Click <span class="iconify" data-icon="mdi:console" title="Shell">Shell</span> and enter an option in the **Choose Shell Details** window to access a container shell.

Click <i class="material-icons" aria-hidden="true" title="Volume Mounts">folder_open</i> to view configured storage mounts for the container.

Click <span class="iconify" data-icon="mdi:text-box" title="Logs">Logs</span> to open the **Container Logs** window.
Select options in **Logs Details** and click **Connect** to view logs for the container.

## Managing Container Images

{{< include file="/static/includes/apps/AppsManageImages.md" >}}

## Managing Custom Apps

[Installed custom applications](/managing-apps/installing-custom-apps) show on the **Installed** applications screen.
Many of the management options available for catalog applications are also available for custom apps.

TrueNAS monitors upstream images and alerts when an updated version is available.
Update custom applications using the [same procedure](/managing-apps/managing-installed-apps/#updating-apps) as catalog applications.

{{< trueimage src="/images/Apps/CustomAppDetails.png" alt="App Details Widgets" id="App Details Widgets" >}}

Custom applications installed via YAML do not include the **Web UI** button on the **Application Info** widget.
To access the web UI for a custom app, navigate to the port on the TrueNAS system, for example, *hostname.domain:8080*.

### Converting Catalog to Custom Applications

To convert an installed catalog application to a custom YAML application, select the app row and click <i class="material-icons" aria-hidden="true" title="more_vert">more_vert</i> on the **Application Info** widget, then select **Convert to custom app** from the dropdown menu.
Converting to a custom app direct editing to YAML configuration file.

{{< trueimage src="/images/apps/ConvertToCustomAppDialog.png" alt="Convert to Custom App Dialog" id="Convert to Custom App Dialog" >}}

{{< hint type=warning title="Permanent Action" >}}
**Convert to custom app** is a one-time, permanent operation.
Once converted, an custom application cannot be converted back to a catalog version.
{{< /hint >}}

Select **Confirm** then click **Convert** to begin the conversion process.

## Next Steps

{{< include file="/static/includes/managing-apps-next-steps.md" >}}

{{< managing-apps-return-button >}}
