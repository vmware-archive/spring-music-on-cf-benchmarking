#/bin/bash

JMETER_PATH=YOUR_path/apache-jmeter-2.11
JMETER_SCRIPT_PATH=.

TEST_DESCRIPTION=$1

START_TIME_STR=`date "+%Y-%m-%d-%H%M"`

APP_DEPLOY_HOSTNAME=YOUR_hostname
APP_PORT=80
THREADS=2
THREAD_LOOPS=40

echo Time $START_TIME_STR > out/test-$START_TIME_STR.txt
echo Host $APP_DEPLOY_HOSTNAME >> out/test-$START_TIME_STR.txt
echo Thrs $THREADS >> out/test-$START_TIME_STR.txt
echo Loop $THREAD_LOOPS >> out/test-$START_TIME_STR.txt
echo TEST_DESCRIPTION >> out/test-$START_TIME_STR.txt

# for the benefit of Mr. Nohup's .out file
echo Time $START_TIME_STR 
echo Host $APP_DEPLOY_HOSTNAME 
echo Thrs $THREADS 
echo Loop $THREAD_LOOPS
echo TEST_DESCRIPTION

bash $JMETER_PATH/bin/jmeter.sh -n \
    -Jhostname=$APP_DEPLOY_HOSTNAME \
    -Jport=$APP_PORT \
    -Jthreads=$THREADS \
    -Jthread_loops=$THREAD_LOOPS \
    -t $JMETER_SCRIPT_PATH/spring-music-wid.jmx \
    -l out/log-$START_TIME_STR.jtl \
    -p ./jmeter.properties

echo EndT `date "+%Y-%m-%d-%H%M"` >> out/test-$START_TIME_STR.txt