---
title: "Frigate Deployment"
description: "Provides instructions to configure TrueNAS and install Frigate to support AI-powered NVR with real-time object detection for IP cameras."
related_app: "/catalog/frigate"
GeekdocShowEdit: true
geekdocEditPath: "edit/main/content/resources/deploy-frigate.md"
tags:
- apps
- security
- surveillance
- ai
- nvr
---

{{< resource-return-button >}}

{{< include file="/static/includes/apps/StableApp.md" >}}

{{< include file="/static/includes/ProposeArticleChange.md" >}}

Frigate is an open-source Network Video Recorder (NVR) built around real-time AI object detection for IP cameras.
It runs entirely locally on your hardware, ensuring your camera feeds never leave your home.
This provides privacy-focused home surveillance with advanced AI features like person, vehicle, and animal detection.

Frigate uses OpenCV and TensorFlow to perform real-time object detection locally for IP cameras.
By offloading object detection to a supported AI accelerator, even modest hardware can run advanced analysis to determine if motion is actually a person, car, or other object of interest.

TrueNAS Frigate app provides a complete local NVR solution designed for privacy-conscious users who want advanced AI-powered video surveillance without relying on cloud services.

Refer to the Frigate app information screen for details on the version and release.

This procedure provides setup instructions for the TrueNAS Frigate app and how to configure it to support AI-powered object detection for your IP camera surveillance system.

TrueNAS offers one deployment option for setting up Frigate, a Linux-based TrueNAS application available in TrueNAS releases 24.10 and later.

## Before You Begin

Before you install the Frigate app:

{{< include file="/static/includes/apps/BeforeYouBeginStableApps.md" >}}
{{< include file="/static/includes/apps/BeforeYouBeginRunAsUser.md" >}}

<div style="margin-left: 33px">{{< trueimage src="/images/Apps/FrigateInfoScreen.png" alt="Frigate App Details Screen" id="Frigate App Details Screen" >}}</div>

{{< include file="/static/includes/apps/BeforeYouBeginAddAppDatasets.md" >}}

<div style="margin-left: 33px">Frigate requires two datasets: <b>config</b> for app configuration files and <b>media</b> for recorded video storage.
You can create a third dataset, <b>cache</b>, or use the <b>tmpfs</b> storage option to create a temporary directory on the RAM for temporary storage and thumbnails.
  
These datasets store different types of data:
* **config** - Contains the Frigate configuration YAML file and other app settings
* **media** - Stores recorded video clips and snapshots 
* **cache** - (Optional) Stores processing and thumbnail generation, or use the **tmpfs** option to create a directory for temporary storage in RAM </div>

For more information on storage configuration options, refer to the storage configuration options in the [Understanding App Installation Wizard Settings](#understanding-app-installation-wizard-settings) section.</div>

* Prepare Hardware Acceleration information (optional)
  
  Frigate performs best with dedicated hardware for video processing and AI object detection.
  Before installing, identify what hardware acceleration is available on your TrueNAS system:

  Intel Integrated Graphics: Check if the device **/dev/dri/renderD128** exists on your system.

  NVIDIA GPU: Verify NVIDIA drivers are installed and your GPU is detected.

  For USB accelerators: Enable **Mount USB Bus** during installation.

  For detailed hardware detection instructions and configuration examples, see https://docs.frigate.video/configuration/hardware_acceleration.

  You need the device paths for any available hardware to enter in the installation wizard.

  {{< expand "Frigate Hardware Acceleration Requirements" "v" >}}

  For optimal performance, Frigate benefits from dedicated hardware acceleration.
  Refer to Frigate documentation for current hardware recommendations.

  Frigate recommendations for CPU and RAM:
  * CPU-only detection (limited performance) at a minimum
  * 2GB RAM minimum, or 4GB+ recommended for multiple cameras

  Frigate recommends setting the **media** dataset to use fast storage (SSD preferred).

  {{< /expand >}}
  {{< expand "Camera Preparation" "v">}}

  Before installing Frigate:

  * Ensure your IP cameras support RTSP streams.
  * Identify the RTSP URL format for your camera(s).
  * Locate and take note of the camera credentials (username/password) and have them ready to enter.
  * Verify camera streams and connectivity with a tool like VLC.
  {{< /expand >}}

## Installing the TrueNAS Frigate App

{{< hint info >}}
This basic procedure covers the required Frigate app settings.
For optional settings, see [Understanding App Installation Wizard Settings](#understanding-app-installation-wizard-settings).
{{< /hint >}}

{{< include file="/static/includes/apps/MultipleAppInstancesAndNaming.md" >}}
{{< include file="/static/includes/apps/LocateAndOpenInstallWizard.md" >}}

{{< trueimage src="/images/Apps/InstallFrigateScreen.png" alt="Install Frigate Screen" id="Install Frigate Screen" >}}

{{< include file="/static/includes/apps/InstallWizardAppNameAndVersion.md" >}}

Next, configure the **Frigate Configuration** settings. You can accept the defaults for many settings, but review the options below for your specific use case.

{{< expand "Entering Frigate Configuration Settings" "v" >}}

{{< trueimage src="/images/Apps/InstallFrigateConfigSettings.png" alt="Install Frigate Configuration Settings" id="Install Frigate Configuration Settings" >}}

Select your local timezone from the **Timezone** dropdown. This ensures timestamps in recordings and logs are accurate for your location.

Choose **Normal Image** in **Image Selector** unless you have specific hardware acceleration requirements.
Advanced users with supported hardware can select optimized images.

Set the **Shared Memory Size** based on your camera setup. Choose the option that applies to your use case.
* **64 MiB** is the default setting for one to two cameras.
* **128 MiB** is for three to five cameras (Frigate recommends this as the minimum for most setups).
* **256 MiB** is for six or more cameras or higher resolution streams.

For specific calculations based on your setup, refer to the [Frigate Installation documentation](https://docs.frigate.video/frigate/installation#calculating-required-shm-size).

Select **Mount USB Bus** if using a USB accelerator or other USB devices for hardware acceleration.

Click **Add** next to **Devices** add hardware acceleration devices (GPU, TPU, etc.).
Refer to the list created in the [Before You Begin](#before-you-begin) section on hardware acceleration for device paths.

You can log into your Frigate account to configure devices such as cameras, detection zones, and set storage retention policies.
Cameras are configured in a yaml file and not in the TrueNAS **Install Frigate** wizard.

The TrueNAS app is configured with the required environment variables. Add custom variables only if needed for your specific configuration.
Environment variables to consider:
* FRIGATE_RTSP_PASSWORD - if using RTSP restreaming in Frigate.
* PLUS_API_KEY - if using Frigate+ (cloud service, subscription required)

{{< /expand >}}

Configure the network settings.

{{< trueimage src="/images/Apps/InstallFrigateNetworkSettings.png" alt="Install Frigate Network Settings" id="Install Frigate Network Settings" >}}

Accept the default port, **30193**, in **Port Number**.
See [Network Configuration](#network-configuration) below for more information.

If you want to bind specific host IPs, click **Add** next to **Host IPs** and enter the IP addresses.

Add your **Storage Configuration** settings. For **Frigate Config Storage**, do the following:

Set **Type** to **Host Path (Path that already exists on the system)**.
Select **Enable ACL**. Use the file browser to navigate to the required dataset. 
If the **config** dataset is not created yet, browse to the parent dataset and click on it to activate the **Create Dataset** option.
Create the **config** dataset. 

{{< trueimage src="/images/Apps/InstallFrigateConfigStorageHostPathACLandACE.png" alt="Frigate Config Storage Settings" id="Frigate Config Storage Settings" >}}

Add an ACE entry for user ID **0** and give it **FULL_CONTROL** permission. 

Select **Force Flag** to allow app upgrades when the dataset has existing data.

Repeat the steps above for **Frigate Media Storage**, selecting the **media** dataset.

{{< trueimage src="/images/Apps/InstallFrigateMediaStorageHostPathACLandACE.png" alt="Frigate Media Storage Settings" id="Frigate Media Storage Settings" >}}

For **Cache Storage**, set **Type** to **tmpfs** to create a directory in RAM for temporary storage (the recommended option).
Select the **Tmpfs Size Limit** option, and accept the default, which is **500**.

Alternatively, to have the cache data persist after restarting the Frigate app, set **Type** to **Host Path**.
Repeat the steps for **Frigate Config Storage** above to set up the host path for the optional **cache** dataset and configure ACL permissions.

{{< trueimage src="/images/Apps/InstallFrigateCacheStorageTmpfs.png" alt="Frigate Cache Storage" id="Frigate Cache Storage" >}}

See [Storage Configuration Settings](#storage-configuration-settings) below for more information.

Accept the defaults in **Resources Configuration**, and select GPU options if applicable.

Click **Install**. A progress dialog displays before switching to the **Installed** applications screen.
The **Installed** screen displays with the **frigate** app in the **Deploying** state. Status changes to **Running** when ready to use.

Click **Web UI** on the **Application Info** widget to open the Frigate web interface.

{{< trueimage src="/images/Apps/FrigateWebUILoginScreen.png" alt="Frigate Web UI Login Screen" id="Frigate Web UI Login Screen" >}}

## Initial Frigate Account Configuration

After deploying the TrueNAS Frigate app, access the Frigate interface to configure your camera settings and object detection zones.

### Camera Configuration

To add camera configuration information in the Frigate app:

* Access the **config** dataset by entering the following command in Shell or an SSH session:

  <code>/mnt/<i>pool/apps/frigate</i>/config</code>).
   
  Where:
  * *pool* is the name of the pool where you created the datasets for the Frigate app.
  * *apps* is the parent dataset for the frigate storage.
  * *frigate* is a parent dataset for the frigate datasets.

  Your mount path might vary based on where you created the datasets for Frigate.

* Configure cameras using the Frigate UI.
  Refer to [Camera Configuration & Object Detection Zones](https://docs.frigate.video/configuration/cameras) and [configuring zones/masks in the Frigate UI](https://docs.frigate.video/configuration/zones) for more information.

Restart the Frigate app to apply changes. On the TrueNAS **Applications** screen, click the **Restart** icon for the Frigate app.

## Understanding App Installation Wizard Settings

The following sections provide detailed explanations of settings in each section of the TrueNAS **Install Frigate** installation wizard.

### Application Name Settings

{{< include file="/static/includes/apps/InstallWizardAppNameAndVersion.md" >}}

### Frigate Configuration Settings

#### Timezone Settings

{{< include file="/static/includes/apps/InstallWizardTimezoneSetting.md" >}}

#### Hardware Acceleration Settings

The **Image Selector** option determines which Frigate image to use. Options are:
* **Normal Image** - Use for standard CPU-based detection.
* **Optimized Images** - Use and available for specific hardware (NVIDIA, Intel, etc.).

Enter the memory you want to allocate for inter-process communication in **Shared Memory Size**.
The default **128 MiB** is suitable for approximately 2 cameras at 720p resolution.
For multiple cameras or higher resolutions, you need to increase this allocation.

To calculate the exact shared memory requirements for your camera setup, use the formula provided in the [Frigate Installation documentation](https://docs.frigate.video/frigate/installation#calculating-required-shm-size):
`(width × height × 1.5 × 20 + 270480) / 1048576` per camera, plus approximately 40MB for logs.

Select **Mount USB Bus** to enable access to USB hardware accelerators.

#### Device Configuration

The **Devices** section allows adding hardware acceleration devices.
Click **Add** to the right of **Devices** to show the **Host Device** and **Container Device** fields. Enter the paths for the devices based on your use case.

Enter `/dev/dri/renderD128` if you have Intel integrated graphics

Enter `/dev/nvidia0`if you have a NVIDIA GPU device

Enter the custom device paths for other accelerators.

#### Environment Variables

{{< include file="/static/includes/apps/InstallWizardEnvironVariablesSettings.md" >}}

### Network Configuration

Accept the default settings in TrueNAS for the Frigate app.

{{< include file="/static/includes/apps/InstallWizardHostNetworSettings.md" >}}

**WebUI Port (Auth)** settings configure the ports for the Frigate app.
**WebUI Port (No Auth)** configures port settings without authentication.

**Port Number** shows the default port **30193** for Frigate web interface.

If the Dockerfile defines an EXPOSE directive, the port is still exposed for inter-container communication regardless of this setting.

{{< include file="/static/includes/apps/InstallWizardDefaultPorts.md" >}}

**Port Bind Mode** sets options for external access, container communication, or no exposure. Port Bind (Auth) and Port Bind Mode have these same options:
* **Publish** - Publishes the port on the host for external access.
* **Expose** - Exposes the port for inter-container communication.
* **None** - Sets the port so it is not exposed or published.

**RTSP Port** specifies the RTSP port for Frigate. It uses the internal port number **8554**, and the bind options are the same as those documented above.

**WebRTC Port** specifies the WebRTC port for Frigate. It uses the internal port number **8555**, and the bind options are the same as those documented above.

**Go2RTC Port** specifies the Go2RTC port for Frigate. The bind options are the same as those documented above.

{{< include file="/static/includes/apps/InstallWizardCertificateSettings.md" >}}

### Storage Configuration Settings

TrueNAS provides two main options for storage volumes: **ixVolumes** and **Host Paths**.
The **tmpfs** option shows for the cache storage option.

{{< include file="/static/includes/apps/InstallAppsStorageConfig.md" >}}

Frigate needs two datasets for host path storage volume configurations:
* **config** for configuration storage. Select as the **Config Storage** volume.
* **media** for media storage. Select as the **Media Storage** volume.

The **Cache Storage** can be set to a host path with a dataset named **cache** or set to the **tmpfs** option, which creates a directory in RAM for temporary file storage, thumbnails, etc.
Using **Host Path** requires a dataset. Using **tmpfs** RAM-based storage is faster, but the directory is cleared on a system restart.

If you nest these datasets under a parent dataset named *frigate*, and use the **Add Dataset** form, you can create a dataset with the **Dataset Preset** set to **Generic** or **Apps**.

Configure the **config** and **media** dataset ACL permissions in the install wizard by adding an ACL entry for the app user.
The app runs as user ID **0** (root). You must configure dataset permissions properly for Frigate to function correctly.
Using **Enable ACL** to set the host path also shows the **ACE Entry** option.
Click **ACE Entry** to show the three entry settings. Set type to user, enter **0** as the user ID, and set permissions to full control.
Select **Force Flag** to allow TrueNAS to update the app when the dataset has data stored.

{{< include file="/static/includes/apps/InstallWizardPostgresStorageAutomaticPermissions.md" >}}

{{< include file="/static/includes/apps/InstallAppsStorageConfig2.md" >}}

### Labels Configuration Settings

{{< include file="/static/includes/apps/InstallWizardLabelsConfiguration.md" >}}

### Resource Configuration Settings

{{< trueimage src="/images/Apps/InstallFrigateResourcesConfig.png" alt="Resources Configuration Settings" id="Resources Configuration Settings" >}}

{{< include file="/static/includes/apps/InstallWizardResourceConfig.md" >}}
{{< include file="/static/includes/apps/InstallWizardGPUPassthrough.md" >}}

## Frigate Troubleshooting

For troubleshooting and advanced configuration, refer to the [official Frigate documentation](https://docs.frigate.video/).
