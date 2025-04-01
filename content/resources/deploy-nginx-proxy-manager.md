---
title: "Nginx Proxy Manager Deployment"
description: "Provides installation instructions for the Nginx Proxy Manager application in TrueNAS."
related_app: "/community-apps/nginx-proxy-manager"
GeekdocShowEdit: true
geekdocEditPath: "edit/main/content/resources/deploy-nginx-proxy-manager.md"
tags:
- apps
---

{{< resource-return-button >}}

{{< include file="/static/includes/apps/CommunityApp.md" >}}

[Nginx Proxy Manager](https://nginxproxymanager.com)

{{< toc >}}

## Installation

There is a notice when you install the app that it needs to run as the `root` user.
What this means practically is that when you are installing the app you will need to set the `User ID` to `0` (instead of `568` or whatever it is on your system).

Nginx Proxy Manager takes a few minutes to install.
When it's running, click on `Nginx Proxy Manager` to go to the details page, then click on the `web portal` button to go to the Nginx Proxy Manager app itself.

The log in credentials on a fresh install are:
* user: admin@example.com
* pass: changeme

{{< include file="/static/includes/ProposeArticleChange.md" >}}
