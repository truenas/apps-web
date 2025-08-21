&NewLine;

* Import or create a self-signed certificate for the app.
  Adding a certificate is optional, but if you want to use a certificate for this application, options vary based on the TrueNAS release:
  * Systems with TrueNAS 25.10 or later can import an existing certificate for the app to use.
  * Systems with the latest maintenance release of 25.04.x or earlier can create a new self-signed CA and then the certificate, or import an existing CA and create the certificate for the app to use. A certificate is not required to deploy the application.
  
  {{< include file="/static/includes/apps/AddAppCertificate.md" >}}