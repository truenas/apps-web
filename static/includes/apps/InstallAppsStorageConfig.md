&NewLine;

{{< expand "Setting the Storage Volume Type" "v" >}}
To allow TrueNAS to create the storage volume, leave **Type** set to **ixVolume (Dataset created automatically by the system)**.
This adds a storage volume for the application nested in the hidden **ix-apps** dataset, located on the pool selected as the apps pool.
ixVolume is suitable for test deployments. For production use, we recommend Host Path with datasets.
Data in ixVolumes does not persist after app deletion, while dataset data remains accessible.

Datasets make recovering, transferring, and accessing app configuration, user, or other data possible where ixVolumes do not. 

If the install wizard shows a **Mount Path**, either accept the default value or enter the correct mount path. For example, if the dataset name is *data*, enter */data* as the mount path. 

To use an existing dataset, which is the recommended option, set **Type** to **Host Path (Path that already exists on the system)**.

{{< hint type=tip >}}
Select **Enable ACL** before using the file browser to populate the **Host Path** field by browsing to select the dataset location.
Selecting **Enable ACL** clears the values in the **Host Path** field, so we recommend selecting **Enable ACL** before entering the host path.

When selecting a dataset for postgres storage, do not use the **Enable ACL** option.
Browse to select the dataset and populate the **Host Path** field, then select the **Automatic Permissions** option to properly set the ACL for postgres storage.
{{< /hint >}}

To browse to select the parent dataset where you want to create a new dataset, expand the file tree by clicking on the arrow to the left of the dataset name.
Click on a dataset to select it and activate the **Create Dataset** option.
Clicking **Create Dataset** opens a dialog where you enter the name for the new dataset, and then click **Create**.
TrueNAS creates the dataset nested under the selected location.
You can use this process to create a parent dataset, and after clicking on the parent dataset, repeat the creation process for a nested child dataset.
{{< include file="/static/includes/apps/AppInstallWizardACLConfiguration.md" >}}

Repeat the above for each required dataset.
{{< /expand >}}