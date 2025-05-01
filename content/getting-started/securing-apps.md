---
title: "Securing Apps"
description: "Securing TrueNAS applications with VPNs and Zero Trust or a Cloudflare Tunnel."
GeekdocShowEdit: true
geekdocEditPath: "edit/main/content/getting-started/securing-apps.md"
doctype: tutorial
tags:
- apps
- vpn
keywords:
  - TrueNAS app security
  - Cloudflare Tunnel TrueNAS
  - secure TrueNAS apps
  - VPN for TrueNAS
  - Zero Trust TrueNAS
  - reverse proxy TrueNAS
  - Nextcloud Cloudflare setup
authors: 
- Fabian Mühlberger
- The TrueNAS Team
---

{{< getting-started-return-button >}}

{{< hint type=note >}}
Enhancing app security is a multifaceted challenge and there are various effective approaches.
We invite community members to share insights on their methods by [contributing](https://www.truenas.com/docs/contributing/applications/) to the documentation.
{{< /hint >}}

## Securing Apps with VPNs and Zero Trust

While applications can greatly expand TrueNAS functionality, making them accessible from outside the local network can create security risks that need to be solved.

{{< hint type=important >}}
Regardless of the VPN or reverse proxy you use, follow best practices to secure your applications:
1. Update installed applications regularly to fix security issues.
2. Use strong passwords and 2FA, preferably TOTP, or passkeys for your accounts.
3. Do not reuse passwords, especially not for admin accounts.
4. Do not use your admin account for daily tasks.
5. Create a separate admin account and password for every application you install.
{{< /hint >}}

## Securing Apps with a Cloudflare Tunnel

This guide shows how to create a Cloudflare tunnel and configure the **Nextcloud** and **Cloudflared** applications in TrueNAS.
The goal is to allow secure access from anywhere.

{{< hint type=important >}}
Exposing applications to the internet can create security risks.
Always follow best practices to secure your applications.

See [additional security considerations](#additional-security-considerations) below.
{{< /hint >}}

Review the [Nextcloud documentation](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/reverse_proxy_configuration.html) to get a better understanding of the security implications before proceeding.

### Setting Up Cloudflare

[Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) is a system that proxies traffic between the user and the application over the Cloudflare network.
It uses a **Cloudflared** client that is installed on the TrueNAS system.

This allows a secure and encrypted connection without the need to expose ports or the private IP of the TrueNAS system to the internet.

{{< trueimage src="/images/Apps/CloudflareTunnelOverview.jpg" alt="Cloudflare Tunnel Overview" id="Cloudflare Tunnel Overview" caption="Illustration via [Cloudflare](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) (CC BY)" >}}

Register or log in to a [Cloudflare account](https://dash.cloudflare.com/sign-up).
A free account is sufficient.

Follow Cloudflare documentation to [register a domain](https://developers.cloudflare.com/registrar/) and set up [DNS](https://developers.cloudflare.com/dns/).

#### Creating a Cloudflare Tunnel

{{< hint type=note >}}
[This video](https://www.youtube.com/watch?v=eojWaJQvqiw) from Lawrence Systems provides a detailed overview of setting up Cloudflare tunnels for applications.
It assumes that the applications run as a docker container, but the same approach can be used to secure apps running on TrueNAS in Kubernetes.
{{< /hint >}}

In the Cloudflare One dashboard:

Go to **Networks** and select **Tunnels**.

Click **Create Tunnel**, choose type **Cloudflared**, and click **Next**.

Choose a **Tunnel Name** and click **Save tunnel**.

Copy the tunnel token from the **Install and run a connector** screen.
This is needed to configure the **Cloudflared** app in TrueNAS.

{{< trueimage src="/images/Apps/CloudflareCreateToken.png" alt="Cloudflare Create Token" id="Cloudflare Create Token" >}}

The operating system selection does not matter as the same token is used for all options.
For example, the command for a docker container is:

```
docker run cloudflare/cloudflared:latest tunnel --no-autoupdate run --token 
eyJhIjoiNjVlZGZlM2IxMmY0ZjEwNjYzMDg4ZTVmNjc4ZDk2ZTAiLCJ0IjoiNWYxMjMyMWEtZjE
2YS00MWQwLWFhN2ItNjJiZmYxNmI4OGIwIiwicyI6IlpqQmpaRE13WXpBdFkyRmpPUzAwWVRCbU
xUZ3hZVGd0TlRWbE9UQmpaakEyTlRFMCJ9
```

Copy the string after `--token`, then click **Next**.

Add a public hostname for accessing Nextcloud, for example *nextcloud.example.com*.

Set service **Type** to **HTTPS**.
Enter the local TrueNAS IP with the Nextcloud container port, for example, *192.168.1.1:9001*.

{{< trueimage src="/images/Apps/CloudflareTunnelHostname.png" alt="Cloudflare Tunnel Hostname" id="Cloudflare Tunnel Hostname" >}}

Go to **Additional application Settings**, select **TLS** from the dropdown menu, and enable **No TLS Verify**.

{{< trueimage src="/images/Apps/CloudflareTunnelTLSSetting.png" alt="Cloudflare Tunnel TLS Setting" id="Cloudflare Tunnel TLS Setting" >}}

Click **Save tunnel**.

The new tunnel displays on the **Tunnels** screen.

#### Installing Cloudflared

After creating the Cloudflare tunnel, go to **Apps** in the TrueNAS UI and click **Discover Apps**.
Search or browse to select the **Cloudflared** app from the **community** train and click **Install**.

Accept the default **Application Name** and **Version**.

Copy the Cloudflare tunnel token from the Cloudflare dashboard

Paste the token from Cloudflare, that you copied earlier, in the **Tunnel Token** field.

All other settings can be left as default.

{{< trueimage src="/images/Apps/CloudflaredApplicationInstall.png" alt="Install Cloudflared" id="Install Cloudflared" >}}

Click **Save** and deploy the application.

#### Nextcloud Configuration

Install the [Nextcloud](/catalog/nextcloud) **stable** application.

The first application deployment could take a while, and starts and stops multiple times.
This is normal behavior.

The [Nextcloud documentation](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/reverse_proxy_configuration.html) provides information on running Nextcloud behind a reverse proxy.
Depending on the reverse proxy and its configuration, these settings might vary.
For example, if you do not use a subdomain, but a path like *example.com/nextcloud*.

If you want to access your application via subdomain (shown in this guide) two environment variables must be set in the Nextcloud application: [overwrite.cli.url](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#overwrite-cli-url) and [overwritehost](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#overwritehost). 
Additionally, you need to clear the **Host** field under **Nextcloud Configuration**, otherwise you cannot set the OVERWRITEHOST variable.

Enter the two environment variables in **Name** as *OVERWRITECLIURL* and *OVERWRITEHOST*.

Enter the address for the Cloudflare tunnel, configured above in **Value**, for example *nextcloud.example.com*.

#### Testing the Cloudflare Tunnel

With the Cloudflare connector and Nextcloud installed and configured, in your Cloudflare dashboard, go to **Networks** and select **Tunnels**.

The status of the tunnel should be **HEALTHY**.

{{< trueimage src="/images/Apps/CloudflareTunnelStateHealthy.png" alt="Cloudflare Tunnel Healthy" id="Cloudflare Tunnel Healthy" >}}

Nextcloud should now be reachable via the Cloudflare Tunnel address, *nextcloud.example.com* in this example, using an HTTPS connection.

### Additional Security Considerations

Use strong user passwords and configure [two-factor authentication](https://docs.nextcloud.com/server/latest/admin_manual/configuration_user/two_factor-auth.html) for additional security.

Cloudflare offers [access policies](https://developers.cloudflare.com/cloudflare-one/policies/access/) to restrict access to the application to specific users, emails, or authentication methods.

Go to **Access**, click **Add an Application**, and select **Self-Hosted**.

Add your Nextcloud application and the domain configured in the Cloudflare tunnel.

{{< trueimage src="/images/Apps/CloudflareAddApplication.png" alt="Cloudflare Add Application" id="Cloudflare Add Application" >}}

Click **Next**.

Create a new policy by entering a **Policy Name**. You can assign groups to this policy or add additional rules.

{{< trueimage src="/images/Apps/CloudflareAddPolicy.png" alt="Cloudflare Add Policy" id="Cloudflare Add Policy" >}}

{{< trueimage src="/images/Apps/CloudflareCreateAdditionalRules.png" alt="Cloudflare Additional Rules" id="Cloudflare Additional Rules" >}}

Click **Next** and **Save**.

{{< hint type=note >}}
There are additional options for policy configuration, but these are beyond the scope of this tutorial.
{{< /hint >}}

## Next Steps

{{< include file="/static/includes/getting-started-next-steps.md" >}}

{{< getting-started-return-button >}}
