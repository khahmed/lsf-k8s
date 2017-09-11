#!/bin/bash 
PATH=$PATH:/home/lsfadmin/lsf-k8s/

prefix=`echo $LSB_JOBNAME | cut -f1 -d"["`
jobname=$prefix-pi-$LSB_JOBID-$LSB_JOBINDEX
image=$1
shift
command="["
while [[ $# -gt 1 ]]
do
    command=$command\""$1"\"
    command=$command" , "
    shift
done
command=$command\""$1"\""]"
echo $command


tee /tmp/job.tmp.$$ << EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: $jobname
spec:
  template:
    metadata:
      name: $jobname 
      labels:
        project: $LSB_PROJECT_NAME
        queue: $LSB_QUEUE
        user: $LSB_SUB_USER
    spec:
      containers:
      - name: $jobname
        image: $image
        command: $command 
      restartPolicy: Never
EOF

kubectl create -f /tmp/job.tmp.$$
pod=""
echo "Waiting to get pod for job"
while [ -z "$pod" ] 
do
    pod=$(kubectl get pods  --show-all --selector=job-name=$jobname --output=jsonpath={.items..metadata.name})
    sleep 1
    echo "Retrying.."
done
echo "pod=$pod"
# This works from command line outside of bash script but seems to exit when run from within the script
#kubectl attach -i $pod
success=0
keep_running="yes"
trap 'keep_running="no"' SIGINT
trap 'keep_running="no"' SIGTERM
while  [ $success -ne  1 ]  && [[ "$keep_running" -eq  "yes" ]] 
do
    success=`kubectl get jobs | grep $jobname | awk '{print $3}'`
    sleep 2
done
if [[ $keep_running == "no" ]]; then
     echo "Got SIGINT or SIGTERM, deleting job"
     kubectl logs $pod
     kubectl delete job $jobname
     exit
fi

echo "Job Finished"
kubectl logs $pod
kubectl delete job $jobname
