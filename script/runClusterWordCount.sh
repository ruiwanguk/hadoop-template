#!/bin/bash

# options
INPUT_DIR=$1
OUTPUT_DIR=$2

# concatinate the jar libraries into one string
# solution from: http://grepalex.com/2013/02/25/hadoop-libjars/
LIBJARS=""
for f in lib/*.jar
do
    if [ -z "${LIBJARS}" ]; then
        LIBJARS="$f"
    else
        LIBJARS="${LIBJARS},$f"
    fi
done

# execute job
hadoop jar ${project.build.finalName}.jar org.harrywang.hadoop.wordcount.WordCount -libjars ${LIBJARS} -conf conf/hadoop/hadoop-cluster.xml ${INPUT_DIR} ${OUTPUT_DIR}