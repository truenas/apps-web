&NewLine;

* Set a pool for applications to use if not already assigned.
  
  You can use either an existing storage pool or create a new one.
  TrueNAS creates the **ix-apps** (hidden) dataset in the pool set as the application pool.
  This dataset is internally managed, so you cannot use this as the parent when you create required application datasets.

  {{< trueimage src="/images/Apps/AppsChooseAPoolForApps.png" alt="Choose A Pool for Apps" id="Choose A Pool for Apps" >}}

  After setting the pool, the **Installed Applications** screen displays **Apps Service Running** on the top screen banner.
