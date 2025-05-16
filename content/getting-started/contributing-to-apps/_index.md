---
title: "Contributing to Apps"
description: "Information on requesting or adding new apps, reporting issues with or making changes to existing apps, and contributing documentation and resources for apps."
GeekdocShowEdit: true
geekdocEditPath: "edit/main/content/getting-started/contributing-to-apps.md"
doctype: how-to
tags:
- contributing
- issues
- support
- apps
---

{{< getting-started-return-button >}}

We welcome community user contributions, issue reporting, and suggestions for new features and apps to create the best possible TrueNAS app user experience!

## App Updates and Releases

Application maintenance is independent of TrueNAS version release cycles.
App version information, features, configuration options, and installation behavior during access might vary from those in documented tutorials.

TrueNAS apps show the **Update** badge and button on any deployed application instance on the **Installed** application screen when a new version is available.
Users can apply the update(s) individually or collectively and at a convenient time based on needs.

To see currently available apps, go to **Apps** and click **Discover Apps** or visit the [TrueNAS Apps repository](https://github.com/truenas/apps) on GitHub.

## Contributing to TrueNAS Application Catalogs

Users can submit changes to an existing application catalogs through the following methods:

### Contributing Applications

The Apps catalog is open for contributions!
For instructions on how to locally develop and test new applications, see the [contributors guide](https://github.com/truenas/apps/blob/master/CONTRIBUTIONS.md) on GitHub.

### Participating in GitHub Discussions

Questions on the development of applications?
Please head over to the [discussions](https://github.com/truenas/apps/discussions) page to ask questions and collaborate with other App Developers.

### Community Forum Feature Requests

To request an application or general Apps service feature change, go to the [TrueNAS Community Forum](https://forums.truenas.com/), and click **Feature Request**.
Read the **About the Feature Requests category - README First** topic, then click **Open Draft** on the top right of the screen.
Populate the new request form with the relevant information for each section, **Problem/Justification**, **Impact**, and **User Story**.
The form guides you on populating these sections.
Click **Create Topic** to add your suggestion to the list of topics.

Users vote and comment on these suggestions.
TrueNAS team members actively monitor this channel and discusses the feasibility of each request both internally and in the forum posts.

If approved and requested to submit a PR to add the new application, submit a PR against the [TrueNAS/Community](https://github.com/truenas/charts/tree/master/community) repository.
Include the relevant files in the PR, including a ReadMe.txt file with any installation notes for TrueNAS developers.

## Contributing to TrueNAS Application Documentation

Community members can now submit content directly to the [TrueNAS Apps Market repository](https://github.com/truenas/apps-web).

For more information about submitting a pull request on GitHub, see the [Updating Content](https://www.truenas.com/docs/contributing/documentation/contentupdate/) at the TrueNAS Contributions Guide.

Here's a version styled more appropriately for Hugo documentation — clean, semantic, and easy to scan, without icons or unnecessary embellishment:

### Proposing Content Changes

To contribute new or updated application documentation, follow the appropriate steps for your task:

#### Setting Up a Fork

* Fork the [`truenas/apps-web`](https://github.com/truenas/apps-web/?tab=readme-ov-file#apps-web) repository.
* When your edits are ready, submit a pull request (PR) against the `main` branch.

#### Editing Existing Application Articles

* Open the relevant `.md` file in the `content/catalog/` directory of your fork.
* Make and commit your changes in your branch.

#### Adding New Tutorials or App Content

* Create a new `.md` file in the `content/resources/` directory.
* Follow the [front matter format](#formatting-front-matter) used in existing examples.

#### Embedding Images

* Save images in the `static/images/` directory and reference them with standard Markdown syntax.

### Adding Resource Content to App Pages

* [Add app resources](#adding-app-resources) for users to access from the app's **Resources** section.
* [Create resource cards](#creating-resource-cards) to link to documentation or external content.
* [Embed](#embedding-resources) YouTube videos to appear in the **Resources** section of the app article.

#### Review Existing Examples and Use Edit Tools

* Use the **Edit page** button in the upper right corner of an app article to propose changes directly from the site (when available).
* Explore the `content/` and `static/` directories in the repository for examples of complete entries and tutorials.

#### Opening a Pull Request

When opening a PR, briefly describe the purpose of your change and what it introduces. This helps reviewers quickly understand the context and impact of your contribution.

### Adding App Resources

The Resources section of each app page helps readers find helpful documentation and community materials related to that app.
Contributors can create [Apps Market repository](https://github.com/truenas/apps-web) pull requests to add links to internal docs, official project pages, tutorials, blog posts, or videos to support different use cases and learning styles.

#### Creating Resource Cards

Resource cards present links to app documentation and resources directly from [Catalog](/catalog) page of the associated app.
Create cards to direct readers to internal documentation, such as when [submitting a new contribution](#contributing-to-truenas-application-documentation), or external resources, such as community posts, blogs, or project-maintained documentation for an app.

Create resource cards using the **doc-card** shortcode.

Open the [/content/catalog](https://github.com/truenas/apps-web/tree/main/content/catalog) file for the app you want to edit and locate the **Resources** section.
Insert a new shortcode call in the **docs-sections** division using the syntax:

```
{{</* doc-card title="TITLE" link="PATH" descr="DESCRIPTION" doctype="TYPE" kind="KIND" */>}}
```

Where:

{{< truetable >}}
| Variable      | Required | Description |
|---------------|----------|-------------|
| **TITLE**     | ✅ | The visible name of the resource, typically the page or article title. |
| **PATH**      | ✅ | The URL or internal path to the resource. For internal docs, use a relative path like `/resources/app-name-file/`; for external links, use the full URL. |
| **DESCRIPTION** | ✅ | A short summary that appears beneath the title on the card. This should briefly explain what the user can expect from the linked resource. |
| **TYPE**      | ❌ | The documentation type label shown on the card. Use `tutorial`, `how-to`, `reference`, or `foundations` for internal docs. Leave blank for external links unless the type is known. See [Labeling Resources](#labeling-resources) for more information. |
| **KIND**      | ❌ | The origin of the resource. Use `official` for iX documentation, `project` for upstream sources, `community` for user-created content, `blog` for blog posts, and `post` for informal sources like forums or Reddit. See [Labeling Resources](#labeling-resources) for more information. |
{{< /truetable >}}

##### Labeling Resources

To help readers quickly identify the purpose and origin of each resource, use the doctype and kind attributes when creating resource cards.
These labels appear as small badges on each card and help distinguish between types of documentation (like tutorials or references) and the source of the material (such as official docs, community posts, or upstream project pages).
Use the tables below to select the most appropriate labels for each resource. Leave either value blank if no label applies.

{{< truetable >}}
| Doc Type      | Description                                                                                                 |
| ------------- | ----------------------------------------------------------------------------------------------------------- |
| `tutorial`    | Hands-on introduction for new users or those looking to deepen their knowledge.                             |
| `how-to`      | Step-by-step guides covering key operations and common tasks.                                               |
| `reference`   | Description of UI screens and fields, including technical information like requirements and specifications. |
| `foundations` | Overviews and deeper dives into key topics, concepts, and clarifications.                                   |
{{< /truetable >}}

{{< truetable >}}
| Kind        | Description                                                                                 |
| ----------- | ------------------------------------------------------------------------------------------- |
| `project`   | Documentation hosted or maintained by the upstream app project.                             |
| `official`  | Documentation created and maintained by the TrueNAS team.                                   |
| `community` | Documentation maintained by members of the TrueNAS community.                               |
| `post`      | Informal community sources, such as forum threads, Reddit posts, or Discord chats.          |
| `blog`      | Personal or company-authored posts that share experiences, tips, or insights about the app. |
{{< /truetable >}}

#### Embedding External Resources

You can embed certain types of outside resources, such as YouTube videos, within the **Resources** section of an app page. To do this, use the Hugo [Youtube shortcode](https://gohugo.io/shortcodes/youtube/) containing the resource ID from the original source.

For example, to embed a YouTube video located at *https&#8203;://www.youtube.com&#8203;/watch?v=abcd_1234*, enter the shortcode `{{</* youtube abcd_1234 */>}}`. In this scenario, **youtube** is the shortcode name, and **abcd_1234** is the original resource ID from the YouTube video.

### Adding New Documentation Articles

Use this guide when contributing a new tutorial for an application available through the TrueNAS Apps catalog.
It covers required front matter formatting, how to customize the official tutorial template, writing and formatting standards, and how to integrate snippet files that explain common configuration steps.

#### Formatting Front Matter

To correctly format the front matter of a new <file> .md </file> file, use the following example as a guide:

```
---
title: "APP_NAME Deployment"
description: "Provides installation instructions for the APP_NAME application in TrueNAS."
related_app: "/catalog/APP_NAME"
GeekdocShowEdit: true
geekdocEditPath: "edit/main/content/resources/FILE-NAME.md"
tags:
- apps
---
```

Including a title, short description, and tag(s) ensures consistency and visibility across all apps content.

#### Using the App Tutorial Template

Feel free to change standard article content by adding or removing sections to fit the app installation process.
Change the front matter <file>description:</file> parameter at the top of the article to suit the subject and content of the new tutorial.
Description text must not exceed 160 alphanumeric or special characters, including spaces between characters.
After updating content, delete commented-out sections providing instructions for using this template when they are no longer needed.
When documenting a **Community** train app, do not delete any commented-out instructions in the COMMUNITY APP INTRO SNIPPETS section.

<div class="docs-sections" id="tutorial-template-link">
{{< doc-card title="Community App Tutorial Template" link="/getting-started/contributing-to-apps/template"
descr="Provides an app tutorial template to customize for new community-maintained app tutorials." >}}
</div>

#### Formatting Tips for Content Development

Standard text emphasis:

* Apply **Bold** to UI elements seen on the screen, including field, button, and navigation option names.
  Use double asterisks preceding and following the name or text string to make it bold.
  Do not use bold in code strings.

* Apply *Italics* to any variable.
  Use single asterisks preceding and following the name or text string to make it italics.
  If using a variable in a code example, use the HTML tags (\<i>\</i>) and not the Markdown tags.

* Apply HTML file tags (<code>\<file>\</file></code>) when entering a path to a file or file name, for example <code>\<file>iso\</file></code>, which renders as <file>iso</file>.

* Apply HTML keyboard tags (<code>\<kbd>\</kbd></code>) to keys on a keyboard, for example <code>\<kbd>Enter\</kbd></code>, which renders as <kbd>Enter</kbd>.

When entering commands, command strings, or code blocks:

* Apply backticks(<code>\`\`</code>) or HTML <code>\<code>\</code></code> tags to format command strings or output, for example <code>\`string\`</code> or <code>\<code>string\</code></code>, which render as <code>string</code>.
  
* Apply HTML <code>\<code>\</code></code> tags to strings with variables.

  * Do not enclose variables in angle or square brackets as these can also be part of command syntax.

  * Do not enter variables in all caps unless the command requires entering the value in all caps.

To create a code block, either use three backticks (<code>```</code>) on the line before and after the content block, or use the HTML code tags.

#### Using the Apps Snippet Library

When creating your articles you can use the library of snippets that contain explanations of settings and configuration instructions for the various app Install Wizard settings in your submitted content.
The Technical Documentation team maintains these snippets, but you can submit change requests for these files just as with full articles if you find content that needs updating or changing.

The tutorial template includes the shortcode that calls these files into the app wizard sections of the Stable Apps and Enterprise Apps tutorials in the Documentation Hub.
To use snippets where the template does not have one, enter the include file shortcode where you want to call another snippet.
The shortcode to call snippet files is <code>{{\<include&nbsp;file="/static/includes/apps/snippetFileName.md">}}</code>, where *snippetFileName.md* is the name of the snippet file.

The following table shows the current list of snippet files.
{{< expand "App Tutorial Snippet Files" "v" >}}
Snippet files are located in the <file>/documentation/static/includes/apps</file> folder.
Not all snippet files in this folder apply to tutorial content.
Refer to the tables below for a list of snippet files with content about tutorial sections.
Open and read snippet files to determine where to use them in your tutorial.

**Community Apps General Snippets**
{{< truetable >}}
| File Name | Snippet Use and Content |
|-----------|-------------------------|
| CommunityApp.md | Introduces Community Apps section tutorials, and contributing content. |
| CommunityPleaseExpand.md | States the tutorial is incomplete or a placeholder needing further development. Use if you are proposing a partial expansion of the content, but further work is needed. |
| CommunityPleaseImprove.md | States the tutorial content is suspected to be out of date or inaccurate. Use if you suspect the Community app documentation is out of date, inaccurate, or needs further improvement. |
{{< /truetable >}}

**Before You Begin Snippets**
{{< truetable >}}
| File Name | Snippet Use and Content |
|-----------|-------------------------|
| BeforeYouBeginStableApps.md | Bullet point for adding the apps pool. Includes warning about choosing an encrypted pool for apps. |
| BeforeYouBeginRunAsUser.md | Bullet point describing where to find the run as user information, and includes a screenshot of the app information screen for the app being documented. |
| BeforeYouBegigAddAppDatasets.md | Bullet point for adding datasets for the app. Does does not include details on adding datasets as these vary by app. |
| BeforeYouBeginAddAppDatasetsProcedure.md | Procedure for correctly creating datasets for apps in an expand/collapse area. |
| InstallWizardPostgresStorageAutomaticPermissions.md | Information on configuring postgres and parent dataset permissions, added in the Before You Begin section but can also be added in the Understanding Application Wizard Settings. |
| BeforeYouBeginAddAppCertificate.md | Bullet point for adding a certificate if required for the app. Also include the AddingAppCertificate.md snippet with detailed instructions on adding a self-signed certificate. |
| AddingAppCertificate.md | Detailed set procedure on adding a self-signed certificate authority (CA) and certificate. |
| BeforeYouBeginAddNewUser.md | Single bullet point and procedure for adding a new user as a TrueNAS app administrator. |
{{< /truetable >}}

**Installing the App**
{{< truetable >}}
| File Name | Snippet Use and Content |
|-----------|---------------------|
| LocateAndOpenInstallWizard.md | Describes locating the app widget, and opening the install wizard for the app. |
| MultipleAppInstancesAndNaming.md | Describes adding more than one instance of the same app and naming it. For example, adding two stable or community app instances, or an enterprise and stable train version of the same app. |
| InstallWizardEnvironVariablesSettings.md | Details the Environment Variable settings. Can use this if the procedure requires adding environment variables, or leave the snippet in the Understanding App Install Wizard section and refer to it for more information. |
| InstallWizardAdvancedDNSSettings.md | Details the Advanced DNS setting options that might be included as part of the app configuration or network configuration settings. |
{{< /truetable >}}

**Understanding App Install Wizard Settings**
{{< truetable >}}
| Wizard Settings | File Name | Snippet Use and Content |
|---------|-----------|---------------------|
| App Name and Version | InstallWizardAppNameAndVersion.md | Details the **Application Name** and **Version** settings. |
| Advanced DNS | InstallWizardAdvancedDNSSettings.md | Details DNS option settings. Might be included as a Network Configuration or App Configuration setting option. |
| Environment Variables | InstallWizardEnvironVariablesSettings.md | Use in the Install Wizard Setting section, or if adding environment variables is required for configuring the app, use in the configuring the app procedure section. |
| Timezone | InstallWizardTimezoneSetting.md |  |
| Network (default ports) | InstallWizardDefaultPorts.md | Details changing the default port assignment. Can use this snippet in the Before You Begin and/or Installing the App sections, but is more suited to the section explaining the Network settings. |
| Host Network  | InstallWizardHostNetworkSettings.md | Details the **Host Network** setting in the Network Configuration section of the wizard. Use when the wizard includes this setting. |
| Certificate ID | InstallWizardCertificateSettings.md | Details **Certificate ID** settings, that might be optional and recommended, or required to deploy the app. Include this snippet if you used the two certificate snippets in the Before You Begin section. |
| Storage Configuration | InstallAppsStorageConfig.md | Adds the **Setting the Storage Volume Type** expand section detailing storage volume types, configuring host path storage volume ACL permissions using the **Enable ACL** and **ACL Entries** options. Does not cover specific datasets required by the app. |
| Storage Configuration | InstallAppsStorageConfig2.md | Adds the **Configuring Additional Storage Volumes** expand section detailing adding additional storage volumes, with a list of the **Additional Storage** types. |
| Storage ACL permissions | InstallWizardStorageACLConfig.md | Details on the Edit ACL and ACE Entries settings. Includes the **Configuring ACE Entries** expand detailing how to add ACE entries, default user IDs for apps, or postgres storage volumes. |
| Additional Storage SMB Option | InstallWizardStorageSMBOption.md | Details on the Additional Storage volume SMB share option. |
| Storage Temporary and tmpfs directories | InstallWizardStorageTemporaryAndTmpfs.md | Details on the **Temporary** and **Tmpfs** directory storage options that are available as primary and/or additional storage volume types, and when to use each. |
| Users and Groups | InstallWizardUserAndGroupConfig.md | Details user and group setting options. |
| Labels Configuration | InstallWizardLabelsConfiguration.md | Details on using Docker label-based configuration. |
| Resource Configuration | InstallWizardResourceConfig.md | Details CPU and memory setting options for all apps. If the app includes GPU passthrough, use with the InstallWizardGPUPassthrough.md snippet. |
| GPU Passthrough | InstallWizardGPUPassthrough.md | Details information on GPU settings if the app includes the GPU passthrough settings. Not present if the app does not detect a GPU device. |
{{< /truetable >}}
{{< /expand >}}

### Suggesting Edits to Existing Articles

Click **Edit page** at the top of the Documentation Hub article to suggest changes to an existing article.

Refer to the [Updating Content](https://www.truenas.com/docs/contributing/documentation/contentupdate/) article on the Docs Hub for more details.

## Next Steps

{{< include file="/static/includes/getting-started-next-steps.md" >}}
