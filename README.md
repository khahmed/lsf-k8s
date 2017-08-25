# lsf-k8s

- Deploy the LSF Master from the App Center see (https://www.ibm.com/developerworks/community/blogs/fe25b4ef-ea6a-4d86-a629-6f87ccf4649e/entry/Enabling_an_LSF_cluster_in_an_IBM_Spectrum_Conductor_for_Containers_cluster?lang=en)
NOTE: The LSF CE must be run on VM with only 2 vcpus to conform with license restrictions. Otherwise install a full LSF environment


- 'docker exec' into LSF master container and change /opt/ibm/lsf/conf/lsbatch/cluster1/configdir/lsb.hosts 
to set MXJ to represent the number of concurrent jobs that can be run.
~~~
Begin Host
.
default    8    ()      ()    ()     ()     ()           # Example
End Host
~~~

- Run 'badmin reconfig' for the changes to take effect

- For integration with Platform Application Center (Portal) need to upgrade to full PAC license to enable the K8S Integration

- Copy the Kuberentes directory into /opt/ibm/pac/gui/conf/application/published  

- Install kubectl in /usr/local/bin
- Set kube credentials so that kubectl command is functional. Preferablly to use service account token so that tokens don't expire https://www.ibm.com/developerworks/community/blogs/fe25b4ef-ea6a-4d86-a629-6f87ccf4649e/entry/Configuring_the_Kubernetes_CLI_by_using_service_account_tokens1?lang=en
 
- Install lsf-k8s-sub.sh in /opt/ibm/lsf/10.1/linux2.6-glibc2.3-x86_64/bin/
- Source . /opt/ibm/lsf/conf/profile.lsf
- Submit job bsub -J test[1-10] -o test%I.out  lsf-k8s-sub.sh perl perl -Mbignum=bpi -wle 'print bpi(2000)'

