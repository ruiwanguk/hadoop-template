#!/bin/sh

# options
INPUT_DIR=$1
OUTPUT_DIR=$2
INTERMEDIATE_DIR=$3
INTERMEDIATE_OUTPUT_DIR=${INTERMEDIATE_DIR}/intermediate_output

# concatinate the jar libraries into one string
# solution from: http://grepalex.com/2013/02/25/hadoop-libjars/
LIB_JARS=""
for f in lib/*.jar
do
    if [ -z "${LIB_JARS}" ]; then
        LIB_JARS="$f"
    else
        LIB_JARS="${LIB_JARS},$f"
    fi
done

# remove the intermediate directory if it exists
hadoop fs -conf conf/hadoop/hadoop-cluster.xml -rmr ${INTERMEDIATE_OUTPUT_DIR}

# execute first job
hadoop jar ${project.build.finalName}.jar org.harrywang.hadoop.wordcount.WordCount -libjars ${LIB_JARS} -conf conf/hadoop/hadoop-cluster.xml ${INPUT_DIR} ${INTERMEDIATE_OUTPUT_DIR}

# check exit code
EXIT_CODE=$?

if [[ ${EXIT_CODE} != 0 ]]; then
    echo "Failed to finish the first job"
    exit ${EXIT_CODE}
else
    echo "The first job has finished successfully"
fi

# execute second job
hadoop jar ${project.build.finalName}.jar org.harrywang.hadoop.wordcount.WordCount -libjars ${LIB_JARS} -conf conf/hadoop/hadoop-cluster.xml ${INTERMEDIATE_OUTPUT_DIR} ${OUTPUT_DIR}

# check exit code
EXIT_CODE=$?

if [[ ${EXIT_CODE} != 0 ]]; then
    echo "Failed to finish the second job"
    exit ${EXIT_CODE}
else
    echo "The second job has finished successfully"
fi




