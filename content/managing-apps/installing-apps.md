---
title: "Installing Apps"
description: "How to install applications from the TrueNAS Apps catalog."
GeekdocShowEdit: true
geekdocEditPath: "edit/main/content/managing-apps/installing-apps.md"
doctype: tutorial
keywords:
- install apps truenas scale
- truenas app installation guide
- app installation wizard truenas
- deploy apps on truenas
- custom app installation truenas
- gpu passthrough truenas
- install custom applications truenas
---

{{< managing-apps-return-button >}}

This article covers installing applications from the TrueNAS catalog.
For details on how to set up app storage, configure global settings, and prepare TrueNAS to deploy applications, see [Initial Setup](/getting-started/initial-setup).
For custom applications, see [Installing Custom Apps](/managing-apps/installing-custom-apps).

The **Installed** applications screen displays **Check Available Apps** before you install the first application.

{{< trueimage src="/images/Apps/AppsInstalledAppsScreenNoApps.png" alt="Installed Applications Screen No Apps" id="Installed Applications Screen No Apps" >}}

Click either **Check Available Apps** or **Discover Apps** to open the **[Discover](/managing-apps/discovering-apps)** screen.

Search for the application widget, then click on that widget to open the information screen for the app and access the installation wizard.

## Using an App Installation Wizard

After clicking on an app widget on the **Discover Apps** screen, the information screen for that app opens.
Click **Install** to open the installation wizard for the application.

{{< trueimage src="/images/Apps/MinIOS3AppInfoScreen.png" alt="Application Information Screen Example" id="Application Information Screen Example" >}}

The installation wizard configuration sections vary by application, with some including more configuration areas than others.
Each application tutorial provides information on steps to take before launching an app installation wizard, but if a tutorial does not exist, click **Install** on the app information screen to open the wizard.
Review settings ahead of time to check for required settings and then exit the wizard to do the necessary steps before returning to install the application.
Click **Discover** on the breadcrumb at the top of the app wizard screen to exit without saving.

{{< hint type="info" title="Community Maintained Apps" >}}
Apps submitted and maintained by community members using the **Custom App** option might not include an installation wizard.
Refer to tutorials created and maintained by the community for more information on deploying and using these applications.
{{< /hint >}}

{{< include file="/static/includes/apps/InstallWizardSettingsOverview.md" >}}

After clicking **Install** on an application wizard screen, the **Installed** applications screen opens showing the application in the **Deploying** state before
changing to **Running**.
Applications that crash show the **Crashed** status. Clicking **Stop** changes the status to **Stopping** before going to **Stopped**.
Click **Start** to restart the application.

The screen defaults to selecting the first app row listed on the **Applications** table and showing the application widgets that first app.
To modify installed application settings, click on the app row in the **Applications** table, then click **Edit** on the **Application Info** widget.

Refer to individual app resources in the [Catalog](/catalog) for more details on configuring application settings.

### GPU Passthrough

Users with compatible hardware can pass through a GPU device to an application for use in hardware acceleration.

GPU devices can be available for the host operating system (OS) and applications or can be [isolated for use in a Virtual Machine (VM)](https://www.truenas.com/docs/scale/scaletutorials/systemsettings/advanced/managegpuscale/).
A single GPU cannot be shared between the OS/applications and a VM.

The GPU passthrough option shows in the **Resources Configuration** section of the application installation wizard screen or the **Edit** screen for a deployed application.

{{< trueimage src="/images/Apps/InstallAppResourceConfigurationGPU.png" alt="Select GPU Passthrough" id="Select GPU Passthrough" >}}

Click **Passthrough available (non-NVIDIA) GPUs** to have TrueNAS pass an AMD or Intel GPU to the application.

**Select NVIDIA GPU(s)** displays if an NVIDIA GPU is available, with [installed drivers](/getting-started/setting-up-apps-service/#installing-nvidia-drivers).
Click **Use this GPU** to pass that GPU to the application.

## Viewing App Logs

Apps stuck in a deploying state can result from various configuration problems.
To check the logs for information on deployment issues encountered, click <span class="iconify" data-icon="mdi:text-box" title="Logs">Logs</span> **View Logs** on the **Workloads** widget for the app.

## Next Steps

{{< include file="/static/includes/managing-apps-next-steps.md" >}}

{{< managing-apps-return-button >}}
