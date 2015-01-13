#Constructing a "bare OS" environment that is similar to CF, without CF
Or better known as, if I wanted to run a existing droplet on its own machine.

## Test "Environment"

* Using a deployed CF environment
	* Download the manifest w/your deployment id and output file
```
bosh download manifest DEPLOYMENT_NAME > DEPLOYMENT_MANIFEST_FILENAME.yml
```
* Edit manifest (see bare-metal-manifest.yml for an example)
   * Remove all the jobs other than 1 you want to be your worker
   * Add in the IP addresses of the machines in other deployments to the resource pool. This prevents collision with your new deployment. (Do this carefully, BOSH error messages if you dupe IP addresses are unclear)
   * Change the job to something simple. In this case I used [the CPI job from bosh-warden-cpi-release](https://github.com/cppforlife/bosh-warden-cpi-release)
   * You'll need to upload the release before deploying
```
bosh upload release releases/bosh-warden-cpi/bosh-warden-cpi-9.yml
```
* Deploy
```
bosh deployment DEPLOYMENT_MANIFEST_FILENAME.yml
bosh deploy
```
* Get the existing deployed in a DEA and copy it to the new "bare-metal" machine
    * ssh into your DEA
    * Find your instance using ```/var/vcap/data/dea_next/db/instances.json```
        * This will be the warden_container_path variable
    * tar up the ```warden_container_path```
    * scp it to the bare metal machine (you may need to do it indirectly)
        * I put it in the ```/var/tmp``` of the bare metal machine but should work anywhere
* Starting the spring-music process
    * Need a fake ```VCAP_APPLICATION``` environment variable
        * [Here's one](http://docs.run.pivotal.io/devguide/deploy-apps/environment-variable.html#VCAP-APPLICATION)
```
VCAP_APPLICATION={"instance_id":"451f045fd16427bb99c895a2649b7b2a",
"instance_index":0,"host":"0.0.0.0","port":61857,"started_at":"2013-08-12
00:05:29 +0000","started_at_timestamp":1376265929,"start":"2013-08-12 00:05:29 
+0000","state_timestamp":1376265929,"limits":{"mem":512,"disk":1024,"fds":16384}
,"application_version":"c1063c1c-40b9-434e-a797-db240b587d32","application_name"
:"styx-james","application_uris":["styx-james.a1-app.cf-app.com"],"version":"c10
63c1c-40b9-434e-a797-db240b587d32","name":"styx-abc","uris":["styx-abc.a1-ap
p.cf-app.com"],"users":null}
```
     * Need a real ```VCAP_SERVICES``` environment variable for the database instance you want to access
```
 {
    "p-mysql": [
      {
        "credentials": {
          "hostname": "10.85.22.127",
          "jdbcUrl": "jdbc:mysql://[REDACTED]@10.85.22.127:3306/cf_a968d4db_2489_4a58_a3f7_f5216fbaee12",
          "name": "cf_a968d4db_2489_4a58_a3f7_f5216fbaee12",
          "password": "[REDACTED]",
          "port": 3306,
          "uri": "mysql://[REDACTED]@10.85.22.127:3306/cf_a968d4db_2489_4a58_a3f7_f5216fbaee12?reconnect=true",
          "username": "[REDACTED]"
        },
        "label": "p-mysql",
        "name": "spring-music-mysql",
        "plan": "100mb-dev",
        "tags": [
          "mysql",
          "relational"
        ]
      }
    ]
  }
```
    * Invocation command line should look like
```
VCAP_APPLICATION=`cat ../app-env-short.txt` VCAP_SERVICES=`cat ../../../env.txt` JAVA_HOME=$PWD/.java-buildpack/open_jdk_jre JAVA_OPTS="-Djava.io.tmpdir=$TMPDIR -XX:OnOutOfMemoryError=$PWD/.java-buildpack/open_jdk_jre/bin/killjava.sh -Xmx382293K -Xms382293K -XX:MaxPermSize=64M -XX:PermSize=64M -Xss995K -Daccess.logging.enabled=false -Dhttp.port=9999" $PWD/.java-buildpack/tomcat/bin/catalina.sh run
```
        * This came from first looking in of the copied dea filesystem
```
/var/tmp/rootfs/app$ more .java-buildpack.log 
```