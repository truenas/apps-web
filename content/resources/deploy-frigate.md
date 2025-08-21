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

This procedure demonstrates how to set up the TrueNAS Frigate app and configure it to support AI-powered object detection for your IP camera surveillance system.

TrueNAS offers one deployment option for setting up Frigate, a Linux-based TrueNAS application available in TrueNAS releases 24.10 and later.
The instructions in this article apply to these TrueNAS 24.10 and later releases.

## Before You Begin

Before you install the Frigate app:

{{< include file="/static/includes/apps/BeforeYouBeginStableApps.md" >}}
{{< include file="/static/includes/apps/BeforeYouBeginRunAsUser.md" >}}

<div style="margin-left: 33px">{{< trueimage src="/images/Apps/FrigateInfoScreen.png" alt="Frigate App Details Screen" id="Frigate App Details Screen" >}}</div>

{{< include file="/static/includes/apps/BeforeYouBeginAddNewAppUser.md" >}}

{{< include file="/static/includes/apps/BeforeYouBeginAddAppDatasets.md" >}}

<div style="margin-left: 33px">Frigate requires two datasets: <b>config</b> for app configuration files and <b>media</b> for recorded video storage. You can create a third dataset, <b>cache</b> or use the <b>tmpfs</b> storage option to create a temporary directory on the RAM for temporary storage and thumbnails.
  
These datasets store different types of data:
- **config** - Contains the Frigate configuration YAML file and other app settings
- **media** - Stores recorded video clips and snapshots 
- **cache** - (Optional) Stores processing and thumbnail generation, or use the **tmpfs** option to create a diectory for temporary storage in RAM </div>
  
<div style="margin-left: 33px">{{< include file="/static/includes/apps/BeforeYouBeginAddAppDatasetsProcedure.md" >}}</div>

<div style="margin-left: 33px">You must configure dataset permissions properly for Frigate to function correctly.
The app runs as user ID **568** (apps), so datasets need appropriate permissions.

To configure dataset permissions:
1. Create the required datasets: **config**, **media**, and **cache** (optional).
2. Set permissions for each dataset to allow the apps user (ID 568) full access.
3. Configure additional ACL permissions in the app installation wizard as described below.

{{< include file="/static/includes/apps/InstallWizardPostgresStorageAutomaticPermissions.md" >}}

Finish the permission configuration in the app installation wizard as described in the [installation procedure](#installing-the-frigate-app) below.</div>

{{< expand "Frigate Hardware Requirements" "v" >}}

For optimal performance, Frigate benefits from dedicated hardware acceleration:

* Frigate recommends Google Coral USB/PCIe TPU, Intel integrated graphics with VAAPI, or NVIDIA GPU
* Frigate recommended minimum is CPU-only detection (limited performance)
* Frigate recommended RAM is 2GB minimum, 4GB+ recommended for multiple cameras
* Frigate recommended storage for the **media** dataset is to use fast storage (SSD preferred)

{{< /expand >}}
{{< expand "Camera Preparation" "v">}}

Before installing Frigate:

* Ensure your IP cameras support RTSP streams
* Know the RTSP URL format for your camera(s)
* Have camera credentials (username/password) ready
* Test camera streams with a tool like VLC to verify connectivity
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
Configure the following key settings:

Select your local timezone from the **Timezone** dropdown. This ensures timestamps in recordings and logs are accurate for your location.

Choose **Normal Image** in **Image Selector** unless you have specific hardware acceleration requirements. Advanced users with supported hardware can select optimized images.

Set the **Shared Memory Size** based on your camera setup. Select the option that applies to your use case:
- **64 MiB** - The default setting for 1-2 cameras.
- **128 MiB** - The recommended setting for 3-5 cameras.
- **256 MiB** - The setting for 6+ cameras or higher resolution streams.

Check **Mount USB Bus** if you are using a Google Coral USB accelerator or other USB devices for hardware acceleration.

Click **Add** next to **Devices** to configure hardware acceleration. Select the option for your use case:
- For Intel integrated graphics, add `/dev/dri` devices
- For NVIDIA GPUs, add appropriate GPU devices
- For Google Coral, USB devices are auto-detected when mounted

The TrueNAS app is configured with the required environment variables. Add custom variables only if needed for your specific configuration.
{{< /expand >}}

Configure the network settings:

Accept the default port, **30193**, in **Port Number**.
See [Network Configuration](#network-configuration) below for more information.

If you want to bind specific host IPs, click **Add** next to **Host IPs** and enter the IP addresses.

Add your **Storage Configuration** settings:

Set **Type** to **Host Path (Path that already exists on the system)** for **Frigate Config Storage**.
Select **Enable ACL**, then browse to select the **config** dataset.

{{< trueimage src="/images/Apps/InstallFrigateStorageHostPathConfigACLandACE.png" alt="Install Frigate Config Storage" id="Install Frigate Config Storage" >}}

Select **Force Flag** to allow app upgrades when the dataset has existing data.

Configure the host path for **Frigate Media Storage** by selecting **Host Path** in **type**.
Select **Enable ACL**. 
Browse to select the **media** dataset.
Add ACE entries for user ID **568** with **FULL_CONTROL** permission.

{{< trueimage src="/images/Apps/InstallFrigateStorageHostPathMediaACLandACE.png" alt="Install Frigate Media Storage" id="Install Frigate Media Storage" >}}

**Cache Storage**
For the **Cache Storage**, you can set **Type** to **tmpfs** to create a directory in RAM for temporary storage, or set **Type** to **Host Path** and then browse to select the otpional **cache** dataset.

If selecting the host path option, select **Enable ACL** and configure permissions similar to media storage.
If selecting the tmpfs option, select the **Tmpfs Size Limit**. The default is **500**.

{{< trueimage src="/images/Apps/InstallFrigateStoragetmpfsCacheStorage.png" alt="Install Frigate tmpfs Cache Storage" id="Install Frigate tmpfs Cache Storage" >}}

See [Storage Configuration Settings](#storage-configuration-settings) below for more information.

Accept the defaults in **Resources Configuration**, and select GPU options if applicable.

Click **Install**. A progress dialog displays before switching to the **Installed** applications screen.
The **Installed** screen displays with the **frigate** app in the **Deploying** state. Status changes to **Running** when ready to use.

Click **Web UI** on the **Application Info** widget to open the Frigate web interface.

{{< trueimage src="/images/Apps/FrigateWebUILoginScreen.png" alt="Frigate Web UI Login Screen" id="Frigate Web UI Login Screen" >}}

## Initial Frigate Account Configuration

After deploying the TrueNAS Frigate app, log into your Frigate account to configure your camera settings and object detection zones.

### Camera Configuration

To modify the Frigate app to add camera configuration information:

1. Access the **config** dataset (typically <code>/mnt/<i>pool/apps/frigate</i>/confi</code>).
   Where:
   - *pool* is the name of the pool where you created the datasets for the Frigate app.
   - *apps** is the parent dataset for the frigate storage.
   - *frigate* is a parent dataset for the frigate datasets.

   Your mount path might vary based on where you created the datasets for Frigate.
2. Create or edit the `config.yml` file with your camera configuration. See the example below.
3. Restart the Frigate app to apply changes. From the **Apps** screen, click the **Restart** icon for the Frigate app to restart the app.

Basic camera configuration example:
```yaml
cameras:
  front_door:
    ffmpeg:
      inputs:
        - path: rtsp://username:password@camera-ip:554/stream1
          roles:
            - detect
            - record
    detect:
      width: 1920
      height: 1080
```

### Object Detection Zones

Modify the config.yaml file to add detection zones to focus on specific areas and reduce false positives. See the example below.

```yaml
cameras:
  front_door:
    zones:
      entry_area:
        coordinates: 100,100,400,100,400,300,100,300
```

## Understanding App Installation Wizard Settings

The following sections provide detailed explanations of settings in each section of the **Install Frigate** installation wizard.

### Application Name Settings

{{< include file="/static/includes/apps/InstallWizardAppNameAndVersion.md" >}}

### Frigate Configuration Settings

#### Timezone Settings

{{< include file="/static/includes/apps/InstallWizardTimezoneSetting.md" >}}

#### Hardware Acceleration Settings

The **Image Selector** option determines which Frigate image to use. Options are:
- **Normal Image** - Use for standard CPU-based detection.
- **Optimized Images** - Use and available for specific hardware (NVIDIA, Intel, etc.).

Enter the memory you want to allocate for inter-process communication in **Shared Memory Size**. Options are:
- **64 MiB** - Suitable for 1-2 cameras at 1080p.
- **128 MiB** - Recommended for 3-5 cameras.
- **256 MiB or higher** - Best for many cameras or 4K streams.

Select **Mount USB Bus** to enable access to USB devices like Google Coral TPU accelerators.

#### Device Configuration

**Devices** section allows adding hardware acceleration devices. Click **Add** to the right of **Devices** to show the **Host Device** and **Container Device** fields. Enter the paths for the devices based on your use case.
- Enter `/dev/dri/renderD128` if you have Intel integrated graphics
- Enter `/dev/nvidia0`if you have an NVIDIA GPU device
- Enter the custom device paths for other accelerators.

#### Environment Variables

{{< include file="/static/includes/apps/InstallWizardEnvironVariablesSettings.md" >}}

### Network Configuration

Accept the default settings in TrueNAS for the Frigate app.

{{< include file="/static/includes/apps/InstallWizardHostNetworSettings.md" >}}

**WebUI Port (Auth)** settings configure the ports for the Frigate app.
**Port Number** uses the default **30193** for Frigate web interface.

Note: If the Dockerfile defines an EXPOSE directive, the port is exposed for inter-container communication regardless of this setting.

{{< include file="/static/includes/apps/InstallWizardDefaultPorts.md" >}}

**Port Bind Mode** has options for external access, container communication, or no exposure:
- **Publish** - Publishes the port on the host for external access.
- **Expose** - Exposes the port for inter-container communication.
- **None** - Does not expose or publish the port.

**WebUI Port (No Auth)** settings configure the port setting without authentication.

**Port Bind Mode** shows the same options as the **Port Bind (Auth**) setting documented above.

**RTSP Port** is the RTSP port for Frigate; it uses the internal port number **8554**, and the bind options are the same as those documented above.

**WebRTC Port** is the WebRTC port for Frigate; it uses the internal port number **8555**, and the bind options are the same as those documented above.

**Go2RTC Port** is the Go2RTC port for Frigate, and the bind options are the same as those documented above.

{{< include file="/static/includes/apps/InstallWizardCertificateSettings.md" >}}

### Storage Configuration Settings

TrueNAS provides two options for storage volumes: ixVolumes and host paths. The **tmpfs** option shows for the cache storage option.

{{< include file="/static/includes/apps/InstallAppsStorageConfig.md" >}}

Frigate needs two datasets for host path storage volume configurations:

* **config** for the **Config Storage** volume.
* **media** for the **Media Storage** volume.
* **cache** (optional) for temporary storage, or you can use the **tmpfs** option to create a directory in RAM for temporary file storage, thumbprints, etc.
  Using **Host Path** requires a dataset. Using **tmpfs** is RAM-based storage that is faster but cleared on a system restart.

If you nest these datasets under a parent dataset named *frigate*, you can create this frigate dataset with the **Dataset Preset** set to **Generic** or **Apps**.

Configure both the **config** and **media** dataset ACL permissions as described in the [Before You Begin](#before-you-begin) section.

{{< include file="/static/includes/apps/InstallAppsStorageConfig2.md" >}}

### Labels Configuration 

{{< include file="/static/includes/apps/InstallWizardLabelsConfiguration.md" >}}

### Resource Configuration

{{< trueimage src="/images/Apps/InstallFrigateResourcesConfig.png" alt="Resources Configuration Settings" id="Resources Configuration Settings" >}}

{{< include file="/static/includes/apps/InstallWizardResourceConfig.md" >}}
{{< include file="/static/includes/apps/InstallWizardGPUPassthrough.md" >}}

## Advanced Configurations

The following instructions cover hardware acceleration setups, camera optimizations, and storage retention policies in your Frigate account.

### Hardware Acceleration Setup

For optimal performance, configure hardware acceleration:

**Google Coral TPU**
1. Enable **Mount USB Bus** in the TrueNAS **Install Frigate**  wizard configuration.
   Coral devices are automatically detected.
2. Add to the following to the config.yml: `detector: { type: edgetpu, device: usb }`

**Intel Integrated Graphics**  
1. Add `/dev/dri/renderD128` device
2. Configure VAAPI in config.yml for hardware encoding

**NVIDIA GPU**
1. Add appropriate GPU devices
2. Use NVIDIA-optimized container image
3. Configure hardware encoding in config.yml

### Camera Optimization

When configuring streams:
- Use separate streams for detection (lower resolution) and recording (higher resolution).
- Configure appropriate frame rates (5-10 fps for detection is often sufficient).
- Use H.264 codec for best compatibility.

When setting up detection tuning:
- Adjust detection thresholds to reduce false positives.
- Configure object filters for relevant objects only.
- Use zones to focus detection on important areas.

### Storage Management

To modify retention policies, configure automatic deletion of old recordings. See the example below:

```yaml
record:
  retain:
    days: 7
    mode: motion
snapshots:
  retain:
    default: 14
```
Configure storage monitoring of the media dataset usage.
- Configure alerts for storage capacity.
- Consider automated cleanup scripts for very large deployments.

## Troubleshooting

### Common Issues

**Poor Detection Performance**
- Increase shared memory allocation
- Configure hardware acceleration
- Optimize camera stream settings

**Camera Connection Issues**
- Verify RTSP URLs and credentials
- Test streams outside of Frigate first
- Check network connectivity between TrueNAS and cameras

### Performance Optimization

**CPU Usage**
- Enable hardware acceleration when available
- Reduce detection frame rates
- Use appropriate detection image sizes

**Memory Usage**
- Adjust shared memory size based on camera count
- Monitor RAM usage with multiple cameras
- Consider tmpfs for cache storage

**Network Bandwidth**
- Use appropriate stream resolutions
- Configure separate substreams for detection
- Monitor network utilization during peak usage

For additional troubleshooting and advanced configuration, refer to the [official Frigate documentation](https://docs.frigate.video/).
