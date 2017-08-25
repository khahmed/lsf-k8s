#!/bin/bash
#
# version: 1.3.0
#==========BEGIN MANDATORY-PARAMETERS(INTERNAL USE ONLY, DO NOT CHANGE)===============================


#==========END MANDATORY-PARAMETERS=================================

if [ "x$QUEUE" != "x" ]; then
        SUB_QUEUE_OPT="-q $QUEUE"
else
        SUB_QUEUE_OPT=""
fi 

  
if [ "x$IMAGE" != "x" ]; then
        IMAGE_NAME_OPT="$IMAGE"
else
        IMAGE_NAME_OPT=""
fi 
  
    
if [ "x$COMMAND" != "x" ]; then
        IMAGE_CMD_OPT="$COMMAND"
else
        IMAGE_CMD_OPT=""
fi 
  
  
if [ "x$JOB_NAME" != "x" ]; then
        JOB_NAME_OPT="-J $JOB_NAME"
else
        JOB_NAME_OPT="-J test"
fi
  

#Source COMMON functions
. ${GUI_CONFDIR}/application/COMMON

OUTPUT_FILE_LOCATION_OPT="-o \"$OUTPUT_FILE_LOCATION/output.${EXECUTIONUSER}.txt\""
CWD_DIR="-cwd \"$OUTPUT_FILE_LOCATION\""

JOB_RESULT=`/bin/sh -c "bsub  ${OUTPUT_FILE_LOCATION_OPT} ${CWD_DIR} ${JOB_NAME_OPT} ${SUB_QUEUE_OPT}  /home/lsfadmin/lsf-k8s/lsf-k8s-sub.sh ${IMAGE_NAME_OPT} ${IMAGE_CMD_OPT}   2>&1"`

export JOB_RESULT OUTPUT_FILE_LOCATION
${GUI_CONFDIR}/application/job-result.sh
