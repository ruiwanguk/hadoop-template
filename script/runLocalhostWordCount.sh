#!/bin/bash

# options
INPUT_DIR=$1
OUTPUT_DIR=$2

# execute job
hadoop jar ${project.build.finalName}.jar org.harrywang.hadoop.wordcount.WordCount -conf conf/hadoop/hadoop-localhost.xml ${INPUT_DIR} ${OUTPUT_DIR}