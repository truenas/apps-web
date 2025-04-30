---
title: "Managing Installed Apps"
description: "Provides information on managing apps in TrueNAS including upgrading, deleting, stopping and starting, and managing container images."
GeekdocShowEdit: true
geekdocEditPath: "edit/main/content/managing-apps/managing-installed-apps.md"
tags:
- apps
keywords:
  - TrueNAS app management
  - upgrading TrueNAS apps
  - deleting TrueNAS apps
  - managing Docker apps
  - container image management
  - app installation tutorial
  - TrueNAS workloads management
---

Installed applications appear on the **Installed** applications screen.
Click on an app row to view **Details**, including the **Application Info**, **Workloads**, **Notes**, and **Application Metadata** widgets.

{{< trueimage src="/images/Apps/InstalledAppsScreenWithApps.png" alt="Installed Applications Screen" id="Installed Applications Screen" >}}

## Upgrading Apps

Apps with available upgrades show a yellow circle with an exclamation point on the right side of the **Applications** table row, and the **Installed** application screen banner displays an **Update** or an **Update All** button.
To upgrade an app, select the app row and click **Update** on the **Application Info** widget.
To upgrade multiple apps, either click the **Update All** button on the **Installed** applications banner or select the checkbox to the left of the application row to show the **Bulk Actions** button.
Click **Bulk Actions** and select **Upgrade All** to upgrade the apps selected.
Upgrade options only show if TrueNAS detects an available update for installed applications.

**Update** opens an upgrade window that includes two selectable options, **Images (to be updated)** and **Changelog**.
Click on the down arrow to see the options available for each.

{{< trueimage src="/images/Apps/AppUpdateWindow.png" alt="Update Application Window" id="Update Application Window" >}}

Click **Upgrade** to begin the process. A counter dialog opens showing the upgrade progress.
When complete, the update badge and buttons disappear and the application **Update** state on the **Installed** screen changes from **Update Available** to **Up to date**.

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

## Managing Container Images

{{< include file="/static/includes/apps/AppsManageImages.md" >}}

## Next Steps

{{< include file="/static/includes/managing-apps-next-steps.md" >}}

{{< managing-apps-return-button >}}
