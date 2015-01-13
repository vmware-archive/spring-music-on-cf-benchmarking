#/bin/bash

JMETER_LOG=$1
NAME_NO_PATH=$(basename "$JMETER_LOG")
NAME_NO_EXT="${NAME_NO_PATH%.*}"

rm -f tmp*

# filter out summary lines (which are dupes)
grep --invert-match "samples" $JMETER_LOG > tmp-log-filtered.csv

sort --field-separator="," --key=3,3 --key=1,1n tmp-log-filtered.csv > tmp-log-filtered-sorted.csv

sed -E 's:albums/[0-9a-f\-]+,:albums/spec,:g' tmp-log-filtered-sorted.csv > tmp-log-filtered-sorted-combined.csv

cut -d "," -f 3 tmp-log-filtered-sorted-combined.csv | sort | uniq > tmp-uniq-url-dest.txt

while read DEST; do
	SUFFIX=`echo $DEST|sed 's:[/ ]:-:g'`
    grep "$DEST" tmp-log-filtered-sorted-combined.csv > tmp-$NAME_NO_EXT$SUFFIX.csv
done < tmp-uniq-url-dest.txt

python summarize-stat-csv-column.py 2 tmp-$NAME_NO_EXT*.csv > tmp-summaries.csv

cat tmp-summaries.csv
