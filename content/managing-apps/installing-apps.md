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

TrueNAS applications generally include these basic setting sections:

## Application Name

**Application Name** shows the default name for the application.

If deploying more than one instance of the application, you must change the default name.

Do not change the **Version** number for official apps or those included in a TrueNAS catalog.
When a new version becomes available, the **Installed** application screen shows an update alert, and the
**Application Info** widget shows an **Update** button.
Updating the app changes the version to the currently available release.

## Application Configuration

***Application* Configuration** shows required and optional settings for the app.
Typical settings include user credentials, environment variables, additional argument settings, the name of
the node, or even sizing parameters.

## User and Group Configuration

**User and Group Configuration** shows the user and group ID for the default user assigned to the app.
If not using a default user and group provided, add a new user to manage the application before using the
installation wizard, then enter the UID in both the user and group fields.
This section is not always included in app installation wizards.

## Network Configuration

**Network Configuration** shows network settings the app needs to communicate with TrueNAS and the Internet.
Settings include the default port assignment, host name, IP addresses, and other network settings.

If changing the port number to something other than the default setting, refer to [Default
Ports](https://www.truenas.com/docs/solutions/optimizations/security/#truenas-default-ports) for a list of
used and available port numbers.

Some network configuration settings include the option to add a certificate. Create the certificate
authority and certificate before using the installation wizard if using a certificate is required for the
application.

## Storage Configuration

**Storage Configuration** shows options to configure storage for the application.
Storage configuration can include the primary data mount volume, a configuration volume, postgres volumes,
and an option to add additional storage volumes.
The primary mount volumes have two options:
* **ixVolume** creates a storage volume inside the hidden **ix-apps** dataset. This is the default setting.
* **Host Path** allows you to select an existing dataset created for the application. It shows additional
fields for selecting the path to the dataset and adding the mount point.

ixVolumes are not recommended for permanent storage volumes, they are intended for rapid storage for a test
deployment of the container.
We recommend adding datasets and configuring the container storage volumes with the host path option.

Host paths add existing dataset(s) as the storage volumes.
You can configure the datasets before beginning the app installation using the wizard or click **Create
Dataset** in the app install wizard.

Some applications require specific storage volumes for configuration and other data.
Apps with these requirements indicate this in the wizard UI or details screen.
Refer to tutorials for specifics.

Depending on the app, storage options can include:
* **ixVolume**
* **Host path**
* **SMB share**
* **Tmpfs (Temporary directory created on the RAM)**

See [Understanding App Storage Volumes](/getting-started/app-storage) for more information.

After configuring required storage volumes you can add additional storage volumes.
To configure additional storage volumes for the application, click **Add** to select the type of storage to
configure.

An SMB share option allows you to mount an SMB share as a Docker volume for the application to use.
If the application requires specific datasets or you want to allow SMB share access, configure the
dataset(s) and SMB share before using the installation wizard.

{{< include file="/static/includes/apps/HostPathACL.md" >}}

## Resources Configuration

**Resources Configuration** shows CPU and memory settings for the container pod.
In most cases, you can accept the default settings, or you can change these settings to limit the system
resources available to the application.

Some apps include GPU settings if the app allows or requires GPU passthrough.

### GPU Passthrough

Users with compatible hardware can pass through a GPU device to an application for use in hardware acceleration.

GPU devices can be available for the host operating system (OS) and applications or can be [isolated for use in a Virtual Machine (VM)](https://www.truenas.com/docs/scale/scaletutorials/systemsettings/advanced/managegpuscale/).
A single GPU cannot be shared between the OS/applications and a VM.

The GPU passthrough option shows in the **Resources Configuration** section of the application installation wizard screen or the **Edit** screen for a deployed application.

{{< trueimage src="/images/Apps/InstallAppResourceConfigurationGPU.png" alt="Select GPU Passthrough" id="Select GPU Passthrough" >}}

Click **Passthrough available (non-NVIDIA) GPUs** to have TrueNAS pass an AMD or Intel GPU to the application.

**Select NVIDIA GPU(s)** displays if an NVIDIA GPU is available, with [installed drivers](/getting-started/setting-up-apps-service/#installing-nvidia-drivers).
Click **Use this GPU** to pass that GPU to the application.

## Post-Installation

After clicking **Install** on an application wizard screen, the **Installed** applications screen opens showing the application in the **Deploying** state before
changing to **Running**.
Applications that crash show the **Crashed** status. Clicking **Stop** changes the status to **Stopping** before going to **Stopped**.
Click **Start** to restart the application.

The screen defaults to selecting the first app row listed on the **Applications** table and showing the application widgets that first app.
To modify installed application settings, click on the app row in the **Applications** table, then click **Edit** on the **Application Info** widget.

Settings available for each individual app can differ.
Refer to individual app resources in the [Catalog](/catalog) for more details on configuring application settings.

## Viewing App Logs

Apps stuck in a deploying state can result from various configuration problems.
To check the logs for information on deployment issues encountered, click <span class="iconify" data-icon="mdi:text-box" title="Logs">Logs</span> **View Logs** on the **Workloads** widget for the app.

## Next Steps

{{< include file="/static/includes/managing-apps-next-steps.md" >}}

{{< managing-apps-return-button >}}
