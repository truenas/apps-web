&NewLine;

* (Optional) Create datasets for the storage volumes for the app.
  
  {{< hint type=warning title="Encrypted Datasets" >}}
  Do not create encrypted datasets for apps if they are not required!
  Using an encrypted dataset can result in undesired behaviors after upgrading TrueNAS when pools and datasets are locked.
  When datasets for the containers are locked, the container does not mount, and the apps do not start.
  To resolve issues, unlock the dataset(s) by entering the passphrase/key to allow datasets to mount and apps to start.
  {{< /hint >}}

  You can create the required datasets before or after launching the installation wizard.
  The install wizard includes the **Create Dataset** option for host path storage volumes.
  This allows you to create the parent dataset if you want to organize the required datasets under a parent, or you can create all datasets before you begin installing the app.

  To create datasets before using the **Install Frigate** wizard, go to **Datasets** and select the pool or parent dataset where you want to place the dataset(s) for the app. For example, */tank/apps/appName*.

