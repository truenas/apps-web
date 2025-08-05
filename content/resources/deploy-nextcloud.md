---
title: "Nextcloud Deployment"
description: "Provides instructions to configure TrueNAS and install Nextcloud to support hosting a wider variety of media file previews such as HEIC, Mp4, and MOV files."
related_app: "/catalog/nextcloud"
GeekdocShowEdit: true
geekdocEditPath: "edit/main/content/resources/deploy-nextcloud.md"
tags:
- apps
- media
- imaginary
- redis
---

{{< resource-return-button >}}

{{< include file="/static/includes/apps/StableApp.md" >}}

{{< include file="/static/includes/ProposeArticleChange.md" >}}

Nextcloud is a drop-in replacement for many popular cloud services, including file sharing, calendar, groupware, and more.
One of its more common uses for the home environment is serving as a media backup, and organizing and sharing service.

Nextcloud 24 introduced support for handing off image preview thumbnail generation to an external service, Imaginary, a small HTTP server written in GO.
It receives images over a REST API. Imaginary can upscale, downscale, crop, or resize images.
TrueNAS Nextcloud app users can include Imaginary in their app deployment.

Refer to the Nextcloud app information screen for details on the version and release.

This procedure demonstrates how to set up the TrueNAS Nextcloud app and configure it to support hosting various media file previews, including High-Efficiency Image Container (HEIC), MP4, and MOV files.

TrueNAS Nextcloud app postgres options include a postgres image selector and data storage volume.
TrueNAS Nextcloud app provides backward compatibility and migration of early Nextcloud deployments.

TrueNAS offers one deployment option for setting up Nextcloud, a Linux Debian-based TrueNAS version application available in TrueNAS releases 24.10 and later.
The instructions in this article apply to these TrueNAS 24.10 and later releases.

TrueNAS offered a FreeBSD-based TrueNAS Nextcloud plugin in releases 13.0 and 13, but it is no longer available in TrueNAS 13.0 and is becoming unavailable in 13.3. Refer to release notes for more information on upcoming and current changes.
For more information on the TrueNAS FreeBSD-based Nextcloud plugin, see [Nextcloud](https://www.truenas.com/docs/solutions/integrations/nextcloud/).

## Before You Begin

Before you install the Nextcloud app:

{{< include file="/static/includes/apps/BeforeYouBeginStableApps.md" >}}
{{< include file="/static/includes/apps/BeforeYouBeginRunAsUser.md" >}}

<div style="margin-left: 33px">{{< trueimage src="/images/Apps/NextcloudDetailsScreen.png" alt="Nextcloud App Details Screen" id="Nextcloud App Details Screen" >}}</div>

{{< include file="/static/includes/apps/BeforeYouBeginAddNewAppUser.md" >}}

{{< include file="/static/includes/apps/BeforeYouBeginAddAppDatasets.md" >}}

<div style="margin-left: 33px">Nextcloud requires three datasets: <b>html</b> for app data, <b>data</b> for user data, and <b>postgres_data</b> for the database data storage volume.
Earlier versions of the Nextcloud app relied on four datasets.
If upgrading with an existing deployment of this application, the installation wizard offers an option to migrate these to the new configuration.
  
Nextcloud sets the **Postgres 17** image as the default choice in the **Nextcloud Configuration** section of the installation wizard.
Upgrading a Postgres 13 image deployment to Postgres 17 is a one-way operation. You cannot revert the Postgres 13 image to Postgres 17.
Refer to Nextcloud forums for information on Postgres 17.</div>
  
<div style="margin-left: 33px">{{< include file="/static/includes/apps/BeforeYouBeginAddAppDatasetsProcedure.md" >}}</div>

<div style="margin-left: 33px">You must modify the **data** and **html** dataset ACLs at the time of creation by setting the** @owner** and **Owner Group** to **apps**.
Configure the remaining permissions in the app installation wizard when adding storage volumes, and then configure postgres_data permission with the **Automatic Permissions** option in the app installation wizard as described below.

To change the permissions for the **data** and **html** datasets:
1. Select the dataset (**data** or **html**), scroll down to the **Permissions** widget and click **Edit** to open the **Edit ACL** screen for the selected dataset.
2. Change **root** to **apps** in the **Owner** and **Owner Group** fields, then click **Apply Owner** and **Apply Group**.
3. Click **Save Access Control List**.
4. Select the **data** dataset and repeat steps 1-3 above.

Both datasets are now configured with **apps** as the owner.

{{< include file="/static/includes/apps/InstallWizardPostgresStorageAutomaticPermissions.md" >}}

Finish the permission configuration in the app installation wizard as described in the [installation procedure](#installing-the-nextcloud-app) below.</div>

{{< include file="/static/includes/apps/BeforeYouBeginAddAppCertificate.md" >}}

<div style="margin-left: 33px">Adding a certificate is optional but if you want to use a certificate for this application, create a new self-signed CA and then the certificate or import an existing CA and create the certificate for Nextcloud. A certificate is not required to deploy the application.

* Set up a Nextcloud account.

 If you have an existing Nextcloud account, enter the credentials for that user in the installation wizard.
 If you do not have an existing Nextcloud account, you can create one in the **Nextcloud Configuration** section of the application install wizard.</div>

### Installing the Nextcloud App

{{< hint info >}}
This basic procedure covers the required Nextcloud app settings.
For optional settings, see [Understanding App Installation Wizard Settings](#understanding-app-installation-wizard-settings).
{{< /hint >}}

{{< include file="/static/includes/apps/MultipleAppInstancesAndNaming.md" >}}
{{< include file="/static/includes/apps/LocateAndOpenInstallWizard.md" >}}

{{< trueimage src="/images/Apps/InstallNextcloudScreen.png" alt="Install Nextcloud Screen" id="Install Nextcloud Screen" >}}

{{< include file="/static/includes/apps/InstallWizardAppNameAndVersion.md" >}}

Next, enter the **Nextcloud Configuration** settings. You can accept the defaults for many of the Nextcloud configuration settings except those mentioned in the expandable section below.

{{< expand "Entering Nextcloud Configuration Settings" "v" >}}
Enter the following values:

Enter credentials for the administration user, Redis database, and Nextcloud database.
If you have an existing Nextcloud account with administration credentials and passwords for Redis and Nextcloud databases, enter them in these fields.
If not, create new credentials by entering a new username and password and database passwords now.
Nextcloud does not URL encode in some places so do not use the ampersand (&), at (@), hashtag (#), or percent (%) characters in the Redis password.

- Enter the Nextcloud administration credentials in **Admin User** and **Admin Password**.

- Enter the password for the Redis database in **Redis Password**.

- Enter the Nextcloud database password in **Database Password**.

Scroll down to **Previews** and **Imaginary** and select to enable them if using these options for images.

Change other settings to suit your use case or accept the remaining defaults in the **Nextcloud Configuration** section.

If setting up a cron job schedule, click **Add** to the right of **Tasks** under **Cron** to show the settings that allow you to schedule a cron job.

{{< expand "Nextcloud Cron Jobs" "v" >}}
NextCloud cron jobs only run while the app is running. If you stop the app, the cron job(s) do not run until you start the app again.

For more information on formatting and using cron jobs, see [Managing Cron Jobs](https://www.truenas.com/docs/scale/scaletutorials/systemsettings/advanced/managecronjobsscale/).
{{< /expand >}}

The TrueNAS app is configured with all the required environment variables, but if you want to customize the container, click **Add** to the right of **Additional Environment Variables** for each to enter the variable(s) and values(s).
{{< /expand >}}

Enter the network configuration settings.
Accept the default port, **30125**, in **WebUI Port**, or enter an available port number of your choice.
See [Network Configuration](#network-configuration) below for more information on changing the default port.
This port must match the one used in **Host** above.

If you want to bind IPs on the host to the port number in **30125**, click **Add** to the right of **Host IPs** and enter the IP(s).

If you configured a certificate for Nextcloud, select it in **Certificate ID**.
A certificate is not required unless you want to use an external port other than the default **30125**.

Add your **Storage Configuration** settings.

Set **Type** to **Host Path (Path that already exists on the system)** for **AppData Storage**.
Select **Enable ACL**, then enter or browse to select the **html** dataset to populate the **Host Path** field.

{{< trueimage src="/images/Apps/InstallNextcloudStorageAppDataACLandACESettings.png" alt="Install Nextcloud Storage for AppData" id="Install Nextcloud Storage for AppData" >}}

Select **Force Flag** to allow upgrading the app when the dataset has existing data.

Repeat the storage steps above to configure the host path for **Nextcoud Data Storage**. Enter or select the **data** dataset.

{{< trueimage src="/images/Apps/InstallNextcloudStorageDataACLandACESettings.png" alt="Install Nextcloud Storage for Data" id="Install Nextcloud Storage for Data" >}}

Click **ACE Entries**, and add an entry for **568** with **FULL_CONTROL** permission.

To configure the **Nextcloud Postgres Data Storage** host path, do not select **Enable ACL**!

Set **Type** to **Host Path (Path that already exists on the system)**, then enter or browse to select the **postgres_data** dataset to populate the **Host Path** field.

Select **Automatic Permissions**. This does not show if you selected **Enable ACL**.

See [Storage Configuration Settings](#storage-configuration-settings) below for more information.

Accept the defaults in **Resources Configuration**, and select the GPU option if applicable.

Click **Install**. A progress dialog displays before switching to the **Installed** applications screen.
The **Installed** screen displays with the **nextcloud** app in the **Deploying** state. Status changes to **Running** when ready to use.

Click **Web UI** on the **Application Info** widget to open the Nextcloud web portal sign-in screen.

{{< trueimage src="/images/Apps/NextcloudSignInScreen.png" alt="Nextcloud Sign In Screen" id="Nextcloud Sign In Screen" >}}

## Understanding App Installation Wizard Settings

The following sections provide more detailed explanations of the settings in each section of the **Install Nextcloud** installation wizard.

### Application Name Settings

{{< include file="/static/includes/apps/InstallWizardAppNameAndVersion.md" >}}

### Nextcloud Configuration Settings

Nextcloud configuration settings include setting up credentials, server information like timezone, maintenance window start, and default phone region, performance settings, how previews display (sizing and quality settings), providers, expiration settings, trusted domains and proxies, enabling/disabling related services like Collabora, the host IP and port, adding a cron job with schedule, and adding additional environment variables.

Nextcloud deploys the ffmpeg and smbclient packages for you so these no longer show in the configuration.

#### Timezone Settings

{{< include file="/static/includes/apps/InstallWizardTimezoneSetting.md" >}}

#### Credential Settings

If you have an existing Nextcloud account with Redis and Nextcloud databases, enter the existing administration user credentials in the **Admin User** and **Admin Password** fields.
Enter the existing Redis password in **Redis Password**.
Enter the Nextcloud database password in **Database Password**.

If you do not have an existing account, enter the name and password you want to use to create the Nextcloud login credentials.
Enter a password in **Redis Password** and **Database Password** to set up these areas.

Nextcloud Redis requires a password for access. If you have an existing Nextcloud account with Redis configured, enter that existing password here but if not, enter a password to use for Redis in Nextcloud.
Nextcloud also requires a password to secure access to the database.
If you have an existing Nextcloud account database with a password configured, enter it **Database Password**.
Enter a new password if you do not have an existing database password. The default value is **nextcloud**.
The TrueNAS Nextcloud app passes these passwords to Nextcloud.

#### Tesseract Language Codes

(Optional) To use language codes, click **Add** to the right of **Tesseract Language Code** to show the **Language** field.
Enter the options you want, **chi-sim** for Simplified Chinese or **eng** for English.

For more information on tesseract languages to install for OCRmypdf, see [here](https://tesseract-ocr.github.io/tessdoc/Data-Files-in-different-versions.html) for a list of language codes.
Entering the wrong language code prevents the container from starting.

#### Performance Settings

Select **Run Optimized** to enable Nextcloud optimizations. For more information, visit https://github.com/truenas/containers/blob/master/apps/nextcloud-fpm/configure-scripts/occ-optimize.sh.

**Max Chuncksize (MB)** sets the maximum chunk size for user-chunked uploads. The default setting is **10** MB. 

**PHP Upload Limit (GB)** Sets the PHP upload limit. It applies a timeout to the client_max_body size in nginx, and the post_max_size and upload_max_filesize in PHP. The default value is **3**.

**PHP Memory Limit (MB)** sets the maximum amount of memory a script can consume. The default is **512** MB, with the setting range of 128 to 4096.

#### General Settings

**Maintenance Window Start** sets the start of the maintenance window. The default value is **100**, which disables this feature.
Nextcloud runs some background jobs once a day. When an hour is defined, background jobs advertise themselves as non-time-sensitive are delayed during the working hours and only run in the four hours after the specified time.
A value of 1 runs background jobs between 1:00 a.m. UTC and 5:00 a.m.
Refer to https://docs.nextcloud.com/server/28/admin_manual/configuration_server/background_jobs_configuration.html#maintenance-window-start for more information.

**Default Phone Region** sets the default region for phone numbers for your Nextcloud app (server), using ISO 3166-1 country codes such as DE for Germany, FR for France, etc.
It is required to allow inserting phone numbers in the user profiles starting without the country code (e.g. +49 for Germany). The default value for TrueNAS systems in the United States is **US**.

#### Preview Settings

Nextcloud supports previews of image files.
Preview setting options control enabling and disabling previews, and thumbnail size.
By default, Nextcloud can generate previews for:
* Image files
* Covers of MP3 files
* Text documents

Preview settings have two main settings:
* **Enabled** - Enables the preview settings listed below. When disabled, it does not show previews.
* **Imaginary** - Enables using Imaginary to configure thumbnail settings. 
 Enabling triggers actions(updating configuration, adding the Nextcloud app) on each startup to ensure the configuration is present. 
 Disabling this setting modifies triggered actions (removing the Nextcloud app) upon startup. Configuration is absent when disabled.

For more information on preview settings, refer to [Nextcould documentation](https://docs.nextcloud.com/server/28/admin_manual/configuration_files/previews_configuration.html) and [Nextcloud server configuration](https://docs.nextcloud.com/server/28/admin_manual/configuration_server/config_sample_php_parameters.html#previews).

{{< truetable >}}
| Setting | Default Value | Description |
|*********|***************|*************|
| **Max X** | **2048** | Sets the maximum width, in pixels, of the preview. A value of null means no limit. Nextcloud sets the default to 4096. |
| **Max Y** | **2048** | Sets the maximum height, in pixels, of the preview. Null means no limit. Nextcloud sets the default to 4096. |
| **Max Memory (MB)** | **1024** | Sets the maximum memory available to users to generate an image preview with `imaged`. It reads the image dimensions from the header and assumes 32 bits per pixel. If creating the image allocates more memory, preview generation is disabled and the default mimetype icon shows. Set to -1 for no limit. Nextcloud default is 256 MB. |
| **Max Filesize Image (MB)** | **50** | Sets the maximum file size for generating image previews with `imaged`(default behavior). If the image exceeds the maximum size, it tries other preview generators but most likely shows the default mimetype icon or does not display the image. When set to -1 it sets no limit and tries to generate image previews on all file sizes. The default value is **50**. |
| **JPEG Quality** | **60** | Sets the JPEG quality for preview images. The default value is 60. |
{{< /truetable >}}

The **Square Sizes**, **Width Sizes**, and **Height Sizes** settings show **Size** fields added by the app based on what the preview generation sends to the app.
Default sizes are based on what others used to have balanced size vs quality vs speed.

#### Providers

The **Providers** section shows 10 **Provider** fields with dropdown lists of all available provider options. Modify or accept the default providers to suit your use case.
Nextcloud providers enable registered providers. Other providers are disabled by default due to performance or privacy concerns.

**Add** shows another **Provider** field to select another provider.

#### Expirations

**Activity Expire Days** sets the number of days to keep activity logs. The default setting is **365**.

**Trash Retention** sets the time deleted content is retained. The default value is **auto**.
Defines the policy for when files and folders in the trash bin are permanently deleted.
When the user quota limit is exceeded due to deleted files in the trash bin, retention settings are ignored and files are cleaned up until the quota requirements are met.
The app allows for two settings, a minimum and maximum time for retention.
The minimum time is the number of days files are kept before they are deleted. The maximum time is the number days to keep files after which they are guaranteed to be deleted. The default is auto.
Possible Values:
* **auto** - Keeps files and folders for 30 days, then automatically deletes anytime after that if space is needed.
* **D, auto** - Keeps files and folder in the trashbin for *D* + days, then are deleted anytime after that if space is needed.
* **auto, d** - Deletes all files in the trashbin that are older than *D* days automatically, then deletes files anytime if space is needed.
* **D1, D2** - Keeps files and folders in the trash bin for at least *D1* days and delete when exceeds *D2* days (not automatically deleted if space is needed)
* **disabled** -  Trashbin auto deletes is disabled. Files and folders are kept forever.

See https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/trashbin_configuration.html#deleted-items-trash-bin for more information.

**Versions Retention** sets the time versions are retained. See https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/file_versioning.html for more information.
Version retention defines the policy for when versions are permanently deleted.
Allows for two settings, a minimum and a maximum time for version retention.
The minimum time is the number of days a version is kept before it can be deleted. The maximum time is the number of days after which it is guaranteed to be deleted.
Minimum and maximum times can be set together to define version deletion.
This setting is initially set to **auto**. Possible values:
Available values:
* **auto** - Automatically expire versions according to expire-rules. Refer to Nextcloud Controlling file versions and aging for more information.
* **D, auto** - Keeps versions at least for *D* days, applies expiration rules to all versions older than *D* days.
* **auto, D** - Deletes all versions older than *D* days then automatically deletes other versions according to expire-rules.
* **D1, D2** - Keeps versions for at least *D1* days and deletes when it exceeds *D2* days
* **disabled** - Versions auto-clean when disabled. Versions are kept forever.

#### Cron Job Settings

**Add**, to the right of **Tasks**, shows the **Schedule** and **Command** setting options. Enter the time and day settings in **Schedule** and the command to run in **Command**.
If enabled, **Cron** shows the **Schedule** option. The default value is <b>*/5 * * * *</b>. Enter the schedule values to replace the asterisks based on your desired schedule.

{{< trueimage src="/images/Apps/InstallNextcloudConfigCronSettings.png" alt="Configure Nextcloud Cron Settings" id="Configure Nextcloud Cron Settings" >}}

#### Notify Push Settings

**Notify Push** Enables or disables start-up trigger actions like updating the configuration, adding/removing the Nextcloud app, etc., to ensure the configuration is present or absent. Select **Enable** to enable notification push.

**Collabora** enables or disables the Collabora settings for Nextcloud. Enables/disables start-up trigger actions like updating the configuration, adding/removing the Nextcloud app, etc., to ensure the configuration is  present or absent. Select **Enable** to enable Collabora.

**Onlyoffice** enables or disables the Onlyoffices settings for Nextcloud. It enables/disables start-up trigger actions like updating the configuration, adding/removing the Nextcloud app, etc., to ensure the configuration is present or absent. Select **Enable** to enable Onlyoffice.

**Clamav** enables Clamav settings for Nextcloud. Select **Enable** to enable Clamav.

#### URLs

Sets the protocol, host, and external port for Nextcloud.

**Protocol** Sets the protocol used to access Nextcloud. Options are **HTTP** or **HTTPS**.
When using a reverse proxy, set use HTTPS. When setting up a certificate in the Network Configuration, **HTTPS** is set automatically.

**Host** Set to the host name or IP address of the TrueNAS system with the Nextcloud app.
Do not include the protocol or the port. For example, *cloud.domain.com* or *192.168.1.100*.

**External Port** Set to the external port used to access Nextcloud.
If using a reverse proxy, you most likely want to use 443; leave it set to `0` if not using anything else in front of Nextcloud. For example, *443*.

#### Trusted Domains

**Trusted Domains** sets additional trusted domains for Nextcloud. The **Host** setting and the hosts of Collabora and/or Onlyoffice are automatically added.
Per Nextcloud, this is a list of trusted domains users can LoT into. Specifying trusted domains prevents host-header poisoning. This performs necessary security checks.
Specifying an exact hostname with a permitted port (e.g., demo.example.org:111) disallows other ports on this host.
The asterisk wildcard allows host matching. For example, *ubos-raspberry-pi** allows ubos-raspbery-pi.local and ubos-raspbery-p-2i.local.
Enter an IP address with or without a permitted port (e.g. [2001:db8::1]:8080). Using TLS certificates where commonName=<IP address> is deprecated by Nextcloud.

**Add** shows the **Domain** field where you enter the domains to add as trusted domains.

#### Trusted Proxies

**Trusted Proxies** sets proxies (proxy servers) Nextcloud is to trust. Setting an array that is a combination of IPv4 or IPv6 addresses with or without CIDR notations is possible.
Connections from trusted proxies are specially treated to get the real client information Nextcloud uses in access control and log in.
Trusted proxies provide protection against client spoofing.
When an incoming request remote address matches a specified IP address, it is assumed to be a proxy instead of a client.
Client IPs are read from the HTTP header specified in forwarded headers.
Defaults to an empty array.

**Add** a **Proxy** setting field in addition to the three default proxy fields specifying **10.0.0.0/8**, **172.16.0.0/12**, and **192.168.0.0/16**. 
**10.0.0.0/8** tells Nextcloud to trust any IP in the 10.0.0.0/8 range. IPs in this range are used in large enterprises or Docker. Trusting the entire range is a permissive configuration that assumes all devices in this range are secure and correctly configured proxies. Narrow the range unless you explicitly need the full range.
**172.16.0.0/12** tells Nextcloud to trust any IP in this range. Because the default bridge network for Docker often uses subnets within the 172.16.0.0/12 to 172.117.0.0/16 range, specifying this IP ensures compatibiltiy across Docker networks. Narrow this range to reduce the number of IP addresses to a more limited range of trusted proxies.
**192.168.0.0/16** Tells Nextcloud to trust any IP in this range. It covers IP addresses typically used in home and small office networks. Narrow the range for a more limited range of trusted proxies.

#### Environment Variables
 
{{< include file="/static/includes/apps/InstallWizardEnvironVariablesSettings.md" >}}

Refer to Nextcloud documentation for more information on [environment variables](https://docs.nextcloud.com/server/latest/admin_manual/desktop/envvars.html).

### User and Group Configuration

{{< include file="/static/includes/apps/InstallWizardUserAndGroupConfig.md" >}}

### Network Configuration

The **WebUI Port** settings include:

**Port Bind Mode** options:

* **Publish port on the host for external access** - the port is published on the host for external access.
* **Expose port on the host for external access** - The port is exposed for inter-container communication.
* **None** - The port is not exposed or published.

If the Dockerfile defines an EXPOSE directive, the port can still be exposed for inter-container communication regardless of this setting.

**Port Number** The default web port for Nextcloud is **30125**.

{{< include file="/static/includes/apps/InstallWizardDefaultPorts.md" >}}
{{< include file="/static/includes/apps/InstallWizardAdvancedDNSSettings.md" >}}
{{< include file="/static/includes/apps/InstallWizardCertificateSettings.md" >}}

### Storage Configuration

TrueNAS provides two options for storage volumes: ixVolumes and host paths. 

{{< include file="/static/includes/apps/InstallAppsStorageConfig.md" >}}

Nextcloud needs three datasets for host path storage volume configurations:

* **html** for the **AppData** storage volume.
* **data** for the **User Data** storage volume.
* **postgres_data** for the **Postgres Data** storage volume.

If you nest these datasets under a parent dataset named *nextcloud*, you can create this nextcloud dataset with the **Dataset Preset** set to **Generic** or **Apps**.

Configure both the **data** and **html** dataset ACL permissions as described in the [Before You Begin](#before-you-begin) section.
Change the owner and owner group to the **Apps** user on the **Edit ACL** screen before you configure permissions in the installation wizard storage section.
Failure to do this results in the app not deploying with tracebacks.
Detangling permission issues to get the app to deploy might require deleting the datasets and starting over.

When the app has postgres storage volumes, the process is easier and less prone to permission errors when using the **Automatic Permissions** option in the postgres storage volume section of the install Wizard. 

{{< include file="/static/includes/apps/InstallWizardPostgresStorageAutomaticPermissions.md" >}}

{{< include file="/static/includes/apps/InstallAppsStorageConfig2.md" >}}

#### Setting Dataset ACL Permissions

You can configure ACL permissions for the required dataset in the **Install Nextcloud** wizard, or from the **Datasets** screen any time after adding the datasets.

{{< expand "Adding ACL Permissions from the Datasets Screen" "v">}}
First, select the dataset row, scroll down to the **Permissions** widget, and click **Edit** to open the **Edit ACL** screen.
Change the **@owner** and **@group** values from **root** to the administrative user for your TrueNAS system, and click apply for each.
Next, add an ACL entry for the Diskover Data run-as user **0** for **root**. You can also add the app default user **568** for **apps**.
Also, add the root user for the Elasticsearch root user, user ID **1000**, if permission errors display when trying to deploy the app.
Save the ACL before leaving the screen.
{{< /expand >}}

TrueNAS **Additional Storage** options include mounting an SMB share inside the container pod.
{{< include file="/static/includes/apps/InstallWizardStorageConfig2.md" >}}

#### Mounting an SMB Share Storage Volume

If adding an SMB share as an additional storage volume, create the SMB dataset and share user(s), and add the user ID for the share user(s) to the dataset ACL.
{{< include file="/static/includes/apps/InstallWizardStorageSMBOption.md" >}}

### Labels Configuration 

{{< include file="/static/includes/apps/InstallWizardLabelsConfiguration.md" >}}

### Resource Configuration

{{< trueimage src="/images/Apps/InstallNextcloudResourcesConfig.png" alt="Resources Configuration Settings" id="Resources Configuration Settings" >}}

{{< include file="/static/includes/apps/InstallWizardResourceConfig.md" >}}
{{< include file="/static/includes/apps/InstallWizardGPUPassthrough.md" >}}

### Integrating Nextcloud and Collabora

Users can use Collabora and Nextcloud together. Collabora allows users to open and edit documents stored in their Nextcloud account.
This integration allows users to edit a document simultaneously while providing live comments, suggestions, and version histories.

Users with Collabora and Nextcloud applications installed in TrueNAS can access the Nextcloud UI **Apps** section to find the **Collabora Online** application.

After installing Collabora Online, navigate to the **Collabora Online** tab in Nextcloud and enter your Collabora server address in the **Collabora Online server** field.
This integrates Collabora and Nextcloud accounts, enhancing document access and editing capabilities.

For more details on installing Collabora, visit the [Collabora TrueNAS tutorial](https://apps.truenas.com/resources/deploy-collabora/).