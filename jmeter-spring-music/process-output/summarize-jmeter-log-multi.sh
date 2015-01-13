#/bin/bash

rm -f multi-tmp-*.csv

for TEST_FILE in "$@"
do
    ./summarize-jmeter-log.sh $TEST_FILE >> multi-tmp-alltests.csv
done

head -n 1 multi-tmp-alltests.csv > multi-tmp-result.csv
grep -v "filename, " multi-tmp-alltests.csv >> multi-tmp-result.csv

cat multi-tmp-result.csv