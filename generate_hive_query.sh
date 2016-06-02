#!/bin/sh

if [ -z "$1" ];then
echo "Usage: $0 <FULLY_QUALIFIED_NAME_OF_INPUT_FILE> <HIVE_TABLE_NAME> <HIVE_DB_NAME>"
echo "EXAMPLE : $0 /home/some_directory/input.csv MY_TABLE MY_HIVE_DATABASE"
exit;
fi

if [ -z "$2" ];then
echo "Default Hive database is used as TABLENAME is not provided as the second command line argument."
exit;
else
TABLENAME=$2
fi

if [ -z "$3" ];then
echo "Default Hive database is used as DB_Name is not provided as the third command line argument."
DBNAME="DEFAULT"
else
DBNAME=$3
fi

filename=$1


PREFIX_STMT="Create table MY_TABLE IF NOT EXISTS "

headline=$(head -n 1 $filename)
let COUNTER=0

echo "header line = "$headline

IFS=',' read -ra COLUMN_NAMES <<< "$headline"
for COL in "${COLUMN_NAMES[@]}"; do
    
	#[(col_name data_type [COMMENT col_comment], ...)]	
	if [ $COUNTER -gt 0 ];then
	STMT+=","
	fi
	
	STMT=$STMT" $COL String"
	#echo $STMT
	
	COUNTER+=1
	
	
done


STMT=$STMT" ROW FORMAT DELIMITED FIELDS TERMINATED BY ‘\t’ LINES TERMINATED BY ‘\n’ STORED AS TEXTFILE;"

fullstatement=$PREFIX_STMT" "$STMT

echo "statement= " $fullstatement

exit