#!/bin/sh

# options
INPUT_DIR=$1
OUTPUT_DIR=$2
INTERMEDIATE_DIR=$3
INTERMEDIATE_OUTPUT_DIR=${INTERMEDIATE_DIR}/intermediate_output

# concatinate the jar libraries into one string
# solution from: http://grepalex.com/2013/02/25/hadoop-libjars/
#
# build library jars for hadoop job to move jars into distributed cache
# this is hadoop way of adding dependencies to a cluster
function build_library_jars() {
    LIB_JARS=""

    for f in lib/*.jar
    do
        if [ -z "${LIB_JARS}" ]; then
            LIB_JARS="$f"
        else
            LIB_JARS="${LIB_JARS},$f"
        fi
    done
}

# check exit code, if detect error, then exit the script and print out an error message
# otherwise, print out a success message
function check_exit_code() {
    local exit_code=$1
    local error_message="$2"
    local success_message="$3"

    if [[ $exit_code != 0 ]]; then
        echo $error_message
        exit $exit_code
    else
        echo $success_message
    fi
}

# remove the intermediate directory if it exists
hadoop fs -conf conf/hadoop/hadoop-cluster.xml -rmr ${INTERMEDIATE_OUTPUT_DIR}

# execute first job
hadoop jar ${project.build.finalName}.jar org.harrywang.hadoop.wordcount.WordCount -libjars ${LIB_JARS} -conf conf/hadoop/hadoop-cluster.xml ${INPUT_DIR} ${INTERMEDIATE_OUTPUT_DIR}

# check exit code
check_exit_code $? "Failed to finish the first job" "The first job has finished successfully"

# execute second job
hadoop jar ${project.build.finalName}.jar org.harrywang.hadoop.wordcount.WordCount -libjars ${LIB_JARS} -conf conf/hadoop/hadoop-cluster.xml ${INTERMEDIATE_OUTPUT_DIR} ${OUTPUT_DIR}

# check exit code
check_exit_code $? "Failed to finish the second job" "The second job has finished successfully"



