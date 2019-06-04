#!/bin/bash
# ==============================================================
# CPU limit daemon - set PID's max. percentage CPU consumptions
# ==============================================================

# Variables
CPU_LIMIT=4750
DAEMON_INTERVAL=3  	
BLACK_PROCESSES_LIST=   
WHITE_PROCESSES_LIST=  

# Check if one of the variables BLACK_PROCESSES_LIST or WHITE_PROCESSES_LIST is defined.
if [[ -n "$BLACK_PROCESSES_LIST" &&  -n "$WHITE_PROCESSES_LIST" ]] ; then    
   echo "At least one or both of the variables BLACK_PROCESSES_LIST or WHITE_PROCESSES_LIST must be empty."
   exit 1
elif [[ -n "$BLACK_PROCESSES_LIST" ]] ; then                                
   NEW_PIDS_COMMAND="top -b -n1 -c | grep -E '$BLACK_PROCESSES_LIST' | gawk '\$9>CPU_LIMIT {print \$1}' CPU_LIMIT=$CPU_LIMIT"
elif [[ -n "$WHITE_PROCESSES_LIST" ]] ; then                                 
   NEW_PIDS_COMMAND="top -b -n1 -c | gawk 'NR>6' | grep -E -v '$WHITE_PROCESSES_LIST' | gawk '\$9>CPU_LIMIT {print \$1}' CPU_LIMIT=$CPU_LIMIT"
else
   NEW_PIDS_COMMAND="top -b -n1 -c | gawk 'NR>6 && \$9>CPU_LIMIT {print \$1}' CPU_LIMIT=$CPU_LIMIT"
fi

# Search and limit violating PIDs
while sleep $DAEMON_INTERVAL
do
   NEW_PIDS=$(eval "$NEW_PIDS_COMMAND")                                                                    
   LIMITED_PIDS=$(ps -eo args | gawk '$1=="cpulimit" {print $3}')                                         
   QUEUE_PIDS=$(comm -23 <(echo "$NEW_PIDS" | sort -u) <(echo "$LIMITED_PIDS" | sort -u) | grep -v '^$')   

   for i in $QUEUE_PIDS
   do
       cpulimit -p $i -l $CPU_LIMIT -z &   
   done
done
