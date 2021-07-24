#!/bin/bash
# Monitor a SAP HANA system using sapcontrol
#
# You have to run this script as <sid>adm
# 
# Input parameters:
# $1 = Instance number of the CI


export CLOUDSDK_PYTHON=/usr/bin/python
. $HOME/.profile

PROC_NAME=""
CUR_DATE=`date +"%b %d:%Y-%H:%M:%S"`
ID="${CUR_DATE}:${0}:"

if [[ $# -ne 1 ]]
then
        echo "${ID}Incorrect parameters specified!"
        echo "${ID}Please try again!"
        echo "${ID}e.g. ./chk_h.bash 00"
        exit 1
fi

# Step through each process status of HANA
for f in `sapcontrol -nr ${1} -function GetProcessList | cut -d"," -f4 | tail -n +6`
do

PROC_NAME=`sapcontrol -nr ${1} -function GetProcessList | cut -d"," -f2 | tail -n +6`

if [ "$f" != "Running" ];then
        echo "${ID}Process $PROC_NAME is down!"
        gcloud logging write sandbox_db_alert "${ID}Process $PROC_NAME is down!"
        exit 1
fi
