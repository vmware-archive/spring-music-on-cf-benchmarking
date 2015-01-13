# Spring Music on CF Benchmarking

Using [spring-music](https://github.com/cloudfoundry-samples/spring-music) as a sample application for benchmarking application performance on CF and Linux deployments.

## Test Environment

* Use spring-music as the application under test
  * Primarily monitor application load
    * Responsiveness/error rate to HTTP application requests
    * Application configured to use external mysql data-store (optional)
      * Better simulate real-world scenario
* Application instances
  * deployed on CF
  * one deployed on VM
* Run app specific load that test a mixture of application’s behavior

### Setup Process

* Install (and scale) CF
* Install [Mysql service](https://network.pivotal.io/products/p-mysql)
  * Note you may have to change the maximum number of connections and quota for higher load level tests 
* Create VM for load generator (see ubuntu-server-env/ for example)
* Create mysql service instance (optional)
```
cf create-service p-mysql 100mb-dev spring-music-mysql
```
* Compile, configure, deploy spring music
  * For CF, see [instructions](https://github.com/cloudfoundry-samples/spring-music
  * For VM,
    * can use the same OS as CF (see ```cf-extracted-env/``` folder)
    * can also use "real" Ubuntu OS (see ```ubuntu-server-env``` folder)
* Bind Application to mysql instance (optional)
```
cf bind-service spring-music spring-music-mysql
cf restart spring-music
```
* Setup load generator
  * Install Java (if needed)
  * Install [Apache JMeter](http://http://jmeter.apache.org/)
  * Use script and test definition in ```jmeter-spring-music/``` folder)
* Start load
```
jmeter-spring-music/run_jmeter_spring_music.sh
```
  * Open the script to see the configurable settings

# Analysis Notes
* Jmeter
    * See https://wiki.apache.org/jmeter/LogAnalysis for timestamp help
        * local time for macos seems to be ```=(((A2/1000)-(8*3600))/86400)+(DATEVALUE("1-1-1970") - DATEVALUE("1-1-1904"))```  
    * See http://jmeter.apache.org/usermanual/listeners.html for future output work
    * prefilter the jtl file using ```grep OK ``` to take out the summaries
    * replace the unique album names using Excel replace ```/albums/*``` with ```/albums/specific```


