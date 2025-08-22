&NewLine;

When using a certificate, the best practice is to import an existing certificate if your system is on release 25.10 or later.

Systems with the latest maintenance TrueNAS 25.04.*x* or earlier releases can create a self-signed certificate before using the app installation wizard.

If you did not create a certificate before starting the installation wizard, select the default **TrueNAS** certificate, and then edit the app to change the certificate after deploying the application.

{{< include file="/static/includes/apps/AddAppCertificate.md" >}}

Select the certificate created in TrueNAS for the app from the **Certificate** dropdown list.