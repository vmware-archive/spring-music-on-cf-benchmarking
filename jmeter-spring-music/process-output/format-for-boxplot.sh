# takes n test files
# creates a cfg.csv based on the file names
# creates a headers.csv based on the cfg.csv
# dumps all the data into data.csv

ITERATION=1

rm -f cfg.csv
rm -f headers.csv
rm -f data.csv

echo Experiment,Dest > headers.csv
echo Experiment,Dest > cfgs.csv
echo Expt,Run,Speed > data.csv

for TEST_FILE in "$@"
do
	BASE_FILE=`basename $TEST_FILE`
	EXPT_NAME=${BASE_FILE:13:10}
	DEST=${BASE_FILE:23}	
	echo \"$EXPT_NAME\",\"$DEST\" >> cfgs.csv
    cut -d "," -f 2 $TEST_FILE > tmp-raw-data.txt
    nl -n rz -s , -b a tmp-raw-data.txt > tmp-numbered-data.txt
    awk "{print \"$ITERATION,\" \$0}" tmp-numbered-data.txt >> data.csv
    ITERATION=$((ITERATION+1))
done