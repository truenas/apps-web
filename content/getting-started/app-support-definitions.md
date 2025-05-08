---
title: "App Support Definitions"
description: "Defines the different kinds of informal or formal support offered for applications available within TrueNAS."
related_app:
GeekdocShowEdit: false
doctype: foundations
tags:
- TrueNAS Enterprise Support
- apps
keywords:
- truenas app support levels
- enterprise application support
- truenas community apps
- supported apps truenas scale
- truenas enterprise catalog
---

{{< getting-started-return-button >}}

TrueNAS offers three distinct classes of support for applications, each tailored to provide varying levels of assistance depending on the specific needs and requirements.

This policy outlines the support structure for applications on TrueNAS.  

Users should review these definitions carefully and consult with their support channels if they have specific questions about the level of support applicable to their applications.

<div class="support-cards">
  <div class="support-card community">
    <h2>Community Support</h2>
    <p><strong>Definition:</strong> Applications classified under this tier receive no formal support from TrueNAS official support channels.</p>
    <p><strong>Scope:</strong> Issues related to these applications are 
      <a href="https://github.com/truenas/apps/issues">tracked separately</a> and addressed on a best-effort basis through 
      <a href="https://forums.truenas.com/">community forums</a> and user-driven resources.  
      There is no guaranteed resolution timeframe.</p>
    <p><strong>Examples:</strong> Plex, Tailscale, Jellyfin, NextCloud, and any App available from the Stable or Community trains.</p>
  </div>

  <div class="support-card enterprise-deployment">
    <h2>Enterprise Deployment Support</h2>
    <p><strong>Definition:</strong> Applications listed in the TrueNAS Enterprise Catalog are supported for application deployment 
      and issues related to the TrueNAS application framework.</p>
    <p><strong>Scope:</strong> The TrueNAS Support team includes guidance on the initial deployment and setup of the application within the TrueNAS environment.  
      This is limited to App store configuration, vendor-provided updates, and basic troubleshooting.</p>
    <p>This tier does <strong>not</strong> cover ongoing maintenance or troubleshooting beyond the initial deployment phase or TrueNAS standard configuration.  
      It does <strong>not</strong> cover functionality, compatibility, or performance issues internal to the application itself.</p>
    <p><strong>Examples:</strong> Minio, Asigra.</p>
  </div>

  <div class="support-card enterprise-application">
    <h2>Enterprise Application Support</h2>
    <p><strong>Definition:</strong> Applications in this category are fully supported by both the TrueNAS Support and Development teams.</p>
    <p><strong>Scope:</strong> Comprehensive assistance is provided for troubleshooting, bug fixes, compatibility issues, and integration with new system features.  
      Regular updates and maintenance are included to ensure optimal performance and functionality.</p>
    <p><strong>Examples:</strong> Syncthing, Remote Assistance.</p>
  </div>
</div>

## Next Steps

{{< include file="/static/includes/getting-started-next-steps.md" >}}
