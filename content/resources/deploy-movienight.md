---
title: "MovieNight Deployment"
description: "Provides installation instructions for the MovieNight application in TrueNAS."
related_app: "/catalog/movienight"
GeekdocShowEdit: true
geekdocEditPath: "edit/main/content/resources/deploy-movienight.md"
tags:
- apps
---

{{< resource-return-button >}}

{{< include file="/static/includes/apps/CommunityApp.md" >}}

{{< include file="/static/includes/ProposeArticleChange.md" >}}

[MovieNight](https://github.com/zorchenhimer/MovieNight)

## Installation

This app need pretty much nothing to run, only a optional conf file that you'll map through a a mounted volume.

MovieNight takes a few minutes to install.
When it is running, click on the **web portal** button to go to the MovieNight app itself.
You also need a stream solution, like [OBS](https://obsproject.com/fr) to inject a video stream to broadcast.

For all the configuration, see : [MovieNight :: Readme](https://github.com/zorchenhimer/MovieNight/blob/master/readme.md)

{{< include file="/static/includes/ProposeArticleChange.md" >}}
