---
title: "Discovering Apps"
description: "How to browse the app catalog using the TrueNAS Apps Discover screen."
GeekdocShowEdit: true
geekdocEditPath: "edit/main/content/managing-apps/discovering-apps.md"
doctype: tutorial
keywords:
- discover apps truenas scale
- truenas app catalog
- browse apps truenas
- truenas discover screen guide
- how to find apps in truenas
- refresh truenas app catalog
- truenas app version info
---

{{< managing-apps-return-button >}}

This article covers discovering and evaluating individual apps using the TrueNAS UI.
For details on how to set up app storage, configure global settings, and prepare TrueNAS to deploy applications, see [Initial Setup](/getting-started/initial-setup).
For installing applications from the catalog, see [Installing Apps](/managing-apps/installing-apps).
For custom applications, see [Installing Custom Apps](/managing-apps/installing-custom-apps).

The **Discover** screen shows application widgets based on the trains selected on the **Train Settings** screen.

{{< trueimage src="/images/Apps/AppsDiscoverScreen.png" alt="Applications Discover Screen" id="Applications Discover Screen" >}}

Use the **Discover** screen links to access other functions.

* [**Refresh Catalog**](#refreshing-the-apps-catalog) - Refreshes the list of app widgets after changing train settings or changes to the catalog.
* [**Manage Installed Apps**](/managing-apps/managing-installed-apps) - Opens the **Installed** apps screen where you access the **Configuration** menu to manage general application settings.
* [**Custom App**](/managing-apps/installing-custom-apps) - Allows users to deploy custom applications.

Click on an app widget to open the app information screen with details about the selected application.

{{< trueimage src="/images/Apps/CollaboraInfoScreen.png" alt="Application Information Screen Example" id="Application Information Screen Example" >}}

## Managing Application Catalogs

{{< include file="/static/includes/apps/AppCatalogs.md" >}}

## Understanding Versions

The information screen shows two version identifiers for the selected application: **Version** and **Revision**.

**Version** is the upstream application version — the version of the software released by the upstream project, such as *24.04.10.2.1* for Collabora.
**Version** also appears in the **Application Info** widget on the **Installed** screen.

**Revision** is the TrueNAS catalog revision — the version of the app entry in the [TrueNAS app train](https://github.com/truenas/apps/tree/master/trains), for example *1.2.2*.
The **Revision** identifies catalog packaging updates and appears on the **Installed** screen and in the install wizard for the app.

Updates to an app can involve a new upstream **Version**, a new **Revision**, or both.
The **Applications** table on the **Installed** screen shows **Update available** when the upstream version changes, or **Revision available** when only the catalog revision changes.

## Refreshing the Apps Catalog

Click **Refresh Catalog** on the **Discover** screen to refresh the app catalog.
Refresh the app catalog after adding or editing the app trains on your system.

## Using the Discover Screen Filters

To change how app widgets show on the screen, click the down arrow to the right of **Filters**, and select the filter option to use.

{{< trueimage src="/images/Apps/DiscoverAppsScreenFilterOptions.png" alt="Discover Apps Filter Options" id="Discover Apps Filter Options" >}}

To quickly locate a specific app, begin typing the name in the search field. The screen shows apps matching the typed entry.

To sort app widgets by category, click on **Categories**.
To select multiple categories, click **Categories** again and select another category from the dropdown.

{{< trueimage src="/images/Apps/MinIOS3AppInfoScreen.png" alt="Application Information Screen Example" id="Application Information Screen Example" >}}

After installing an application, the **Installed** applications screen shows the app in the **Deploying** state.
The status changes to **Running** when the application is fully deployed and ready to use.

## Next Steps

{{< include file="/static/includes/managing-apps-next-steps.md" >}}

{{< managing-apps-return-button >}}
