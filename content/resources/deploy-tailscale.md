---
title: "Tailscale Deployment"
description: "Provides installation instructions for the Tailscale application in TrueNAS."
related_app: "/community-apps/tailscale"
GeekdocShowEdit: true
geekdocEditPath: "edit/main/content/resources/deploy-tailscale.md"
tags:
- apps
---

{{< resource-return-button >}}

{{< include file="/static/includes/apps/CommunityApp.md" >}}

{{< include file="/static/includes/ProposeArticleChange.md" >}}

[Tailscale](https://tailscale.com)

{{< toc >}}

## Connecting to a custom headscale server

Add the following to **Extra Arguments**:

`--login-server=https://<yourserver>:<port>`

## Advertising TrueNAS as an exit node

Tick the checkbox next to **Advertise Exit Node**.

Important: Needs enabled IP forwarding on the host via **System > Advanced Settings > Sysctls**.
Please make sure you read and understand the warnings displayed when adding Sysctls
See also [Enable IP forwarding](https://tailscale.com/kb/1019/subnets?tab=linux#enable-ip-forwarding) from Tailscale.
