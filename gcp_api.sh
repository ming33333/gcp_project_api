touch $LOGFILE
echo "" >$LOGFILE

echo "INFO: Starting data parsing from $1"| tee -a $LOGFILE
python parse.py $1
echo "INFO: Finished data parsing from $1"| tee -a $LOGFILE

INPUT=gcp_projects.csv
LOGFILE=bash.log
OLDIFS=$IFS
IFS=','

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

gcloud auth login 2>&1 | tee $LOGFILE
while read project violations
do
	echo "INFO:Updating PROJECT setting : $project" 2>&1 | tee -a $LOGFILE
	gcloud config set project $project 2>&1 | tee -a $LOGFILE
    for violation in $violations
    do
        echo "INFO: Project $project Removing $violation API" 2>&1 | tee -a $LOGFILE
		gcloud services disable $violation 2>&1 | tee -a $LOGFILE
    done
done < $INPUT
IFS=$OLDIFS
