#Constructing a "bare OS" environment

## Test "Environment"

* Download Ubuntu Server LTS (14.04) ISO (or AMI)
* Create Load Generator
        * Create a new VM using the ISO (or AMI)
        * Power up the VM and do installation
        * Install java
        * Download and install jmeter
        * Copy over app benchmarking folder
        * Launch load test
                * Update settings first
* Create Tomcat Server
        * Do installation of VM as above (but DO NOT USE the build in Tomcat Server in Ubuntu)
        * Copy over spring-music
                * Make sure you have a post pull-request #5 version
        * run ```./gradlew assemble``` to get the new WAR file
        * copy the WAR file to tomcat
                * will be something like ```cp build/libs/spring-music.war ~/apache-tomcat-7.0.56/webapps/```
        * Create a DB instance (optional)
        * Put VCAP_SERVICES settings output into ```~/vcap_env.txt```
                * If you need the URL, bind the DB instance to a app and then view that app's env
                * Make sure the format is correct, look at extracted env for an example
        * Start tomcat using ```VCAP_APPLICATION=`cat ~/vcap_app.txt` VCAP_SERVICES=`cat ~/vcap_env.txt` JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64/ JAVA_OPTS="-Djava.io.tmpdir=$TMPDIR -Xmx382293K -Xms382293K -XX:MaxPermSize=64M -XX:PermSize=64M -Xss995K -Daccess.logging.enabled=false -Dhttp.port=9999" ~/apache-tomcat-7.0.56/bin/catalina.sh run``` with the vcap app and env settings from the other environment