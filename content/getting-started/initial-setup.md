---
title: "Initial Setup"
description: "How to configure the TrueNAS Apps storage pool and global settings"
GeekdocShowEdit: true
geekdocEditPath: "edit/main/content/getting-started/initial-setup.md"
doctype: how-to
keywords:
- truenas apps setup
- configure apps service truenas
- truenas docker container apps
- how to install apps truenas scale
- truenas app settings
- manage docker registries truenas
- truenas apps network configuration
---

{{< getting-started-return-button >}}

This article covers how to set up app storage, configure global settings, and prepare TrueNAS to deploy applications.
For details on discovering, installing, and managing individual applications, see [Managing Apps](/managing-apps) and individual app tutorials.

You must choose a pool before you can install an application.
See [Choosing the Apps Pool](#choosing-the-apps-pool) below for more information about apps pool selection.

TrueNAS apps use Docker containers and Docker Compose for deployment.
Docker is an open-source software that manages images and container deployments.

The default system-level settings are found in **Apps > Settings**.

Use the **Configuration** dropdown to access the **Choose Pool**, **Unset Pool**, **Manage Container Images**, and **Settings** options.

For more information on screens and screen functions, refer to the UI Reference article on [Apps Screens](https://www.truenas.com/docs/scale/25.10/scaleuireference/apps/).
Use the dropdown to select your installed TrueNAS version.

## Choosing the Apps Pool

You are prompted to select the pool for apps the first time you click on **Apps**.
You can exit out of this if you are not ready to deploy apps or do not have a pool configured for apps to use for storage.
You must set the pool before you can add any application.

Select the pool and click **Save**.
If you close the dialog to set the pool later, click **Configuration > Choose Pool** to set the pool.

{{< trueimage src="/images/Apps/AppsSettingsChoosePool.png" alt="Choosing a Pool for Apps" id="Choosing a Pool for Apps" >}}

{{< include file="/static/includes/apps/AppsPool.md" >}}

### Migrating Existing Applications

(TrueNAS 25.10 and later)

{{< include file="/static/includes/apps/MigrateExisting.md" >}}

### Unsetting the Apps Pool

To remove the apps pool configuration, click **Unset Pool** on the **Settings** menu.

{{< trueimage src="/images/Apps/AppsUnsetPoolDialog.png" alt="Apps Unset Pool" id="Apps Unset Pool" >}}

Click **Unset** to confirm.
This turns off the apps service until you choose another pool for apps to use.

## Managing Container Images

{{< include file="/static/includes/Apps/AppsManageImages.md" >}}

## Signing In to a Docker Registry

To sign in to a Docker registry, click **Configuration > Sign-in to a Docker registry** to go to the **Docker Registries** screen.

{{< trueimage src="/images/Apps/DockerRegistriesScreen.png" alt="Docker Registries Screen" id="Docker Registries Screen" >}}

Signing in to a registry, such as Docker Hub, is not required but allows you to avoid rate limiting issues or connect to a private registry.

Click **Add Registry** to open the **Create Docker Registry** panel.

{{< trueimage src="/images/Apps/CreateDockerRegistry.png" alt="Create Docker Registry - Docker Hub" id="Create Docker Registry - Docker Hub" >}}

Use the **URI** dropdown to select the Uniform Resource Identifier (URI) type for the registry.
Options are **Docker Hub** or **Other Registry**.
The URI dropdown is hidden when a Docker Hub registry record is already configured.

To sign in to Docker Hub, enter the user name and password of an existing Docker Hub account.

To sign in to another registry, select **Other Registry** from the dropdown or click **Add Registry** again after signing in to Docker Hub.

{{< trueimage src="/images/Apps/CreateDockerRegistryOther.png" alt="Create Docker Registry - Other Registry" id="Create Docker Registry - Other Registry" >}}

Enter a valid Uniform Resource Identifier (URI) for the registry, for example *`https://index.docker.io/v1/`*.
Then enter a display name for the registry record in TrueNAS.

Enter the user name and password of an existing account on the registry.

Click **Save** to sign in and create the registry record.

## Configuring Docker Registry Mirrors

Registry mirrors provide local caching of Docker images to improve performance and reduce bandwidth usage when multiple systems pull images from public registries. Use registry mirrors to avoid hitting rate limits on public registries like Docker Hub.

To configure registry mirrors, go to **Apps > Configuration > Settings** to open the **Settings** screen.

### Adding Registry Mirrors

In the **Settings** screen, locate the **Registry Mirrors** section. This section contains two fields for configuring different types of registry mirrors:

#### Secure Mirror URLs

Use **Secure Mirror URLs** to configure HTTPS-enabled registry mirrors that provide secure connections. Secure mirrors require HTTPS and a valid certificate.

1. Click in the **Secure Mirror URLs** field.

2. Type the registry mirror URL using HTTPS format (e.g., *`https://my-docker-mirror-host`*).

3. Press <kbd>Enter</kbd> to add the URL as a chip.

4. Repeat to add additional secure mirror URLs.

#### Insecure Mirror URLs  

Use **Insecure Mirror URLs** to configure mirrors that use HTTP or HTTPS with self-signed certificates.

{{< hint type="warning" title="Security Consideration" >}}
Insecure registry mirrors can use HTTP connections without encryption or HTTPS with self-signed certificates. Only use insecure mirrors in trusted network environments.
{{< /hint >}}

1. Click in the **Insecure Mirror URLs** field.

2. Type the registry mirror URL (e.g., *`http://my-insecure-mirror-host`* or *`https://my-mirror-with-self-signed-cert`*).

3. Press <kbd>Enter</kbd> to add the URL as a chip.

4. Repeat to add additional insecure mirror URLs.

5. Click **Save** to apply the configuration.

Registry mirrors are used in addition to the original registry. When a mirror is unavailable, Docker falls back to pulling images directly from the original registry.

## Configuring Global Settings

Click **Configuration > Settings** to open the **Settings** screen, which contains options for setting app trains, configuring app networking, installing NVIDIA drivers (if compatible hardware is present), and allowing TrueNAS to monitor for Docker image updates.

{{< trueimage src="/images/Apps/AppsSettingScreen.png" alt="Apps Settings Screen" id="Apps Settings Screen" >}}

### Managing Application Catalogs

{{< include file="/static/includes/apps/AppCatalogs.md" >}}

### Apps Network Settings

Go to **Apps > Installed**, click **Configuration**, and select **Settings**.

To add another range of IP addresses, click **Add** to the right of **Address Pools**, then select a range from the dropdown list of options, and enter the desired value in **Size**.

**Base** shows the default IP address and subnet, and **Size** shows the network size of each docker network that is cut off from the base subnet.

{{< hint type="info" title="Apps Networking Troubleshooting Tip!" >}}
This setting replaces the **Kubernetes Settings** option for **Bind Network** in 24.04 and earlier.
Use to resolve issues where apps experience issues where TrueNAS device is not reachable from some networks.
Select the network option, or add additional options to resolve the network connection issues.
{{< /hint >}}

{{< include file="/static/includes/apps/AppsVMsNoHTTPS.md" >}}

### App Directory Services

{{< include file="/static/includes/apps/AppsDirectoryService.md" >}}

### Installing NVIDIA Drivers

TrueNAS 24.10 (and later) users must manually install drivers from the TrueNAS UI.

1. Go to **Apps > Installed** and click on the **Configuration**.

2. Click on **Settings** to open the **Settings** configuration screen.

3. Select **Install NVIDIA Drivers**, which is available to users with compatible GPUs.

4. Select **Install NVIDIA Drivers**, and click **Save.**

### Monitoring for Image Updates

Select **Check for docker image updates** (selected by default) to enable TrueNAS to periodically check for Docker image updates.
This applies to all Docker images present on the system for either catalog or custom applications.
Disable to prevent TrueNAS from monitoring for upstream image updates.

## Next Steps

{{< include file="/static/includes/getting-started-next-steps.md" >}}
