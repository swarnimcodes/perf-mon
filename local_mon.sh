#!/bin/sh

LOG_FILE="local_perf.log"

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d_%H:%M:%S')

    MEMORY_USED=$(free -h | grep -i "mem" | awk '{print $3}' | sed 's/[^0-9.]//g')
    TOTAL_MEM=$(free -h | grep -i "mem" | awk '{print $2}' | sed 's/[^0-9.]//g')
    MEM_PERCENT=$(echo "scale=2; ($MEMORY_USED / $TOTAL_MEM) * 100" | bc)

    CPU_UTIL_PERC=$(mpstat 1 1 | tail -n 1 | awk '{printf "%.0f%\n", 100 - $NF}')

    DISK_USAGE=$(df -h / | awk 'NR==2 {print $3}' | sed 's/[A-Za-z]//g')
    DISK_SPC=$(df -h / | awk 'NR==2 {print $2}' | sed 's/[A-Za-z]//g')
    DISK_USG_PERC=$(echo "scale=2; ($DISK_USAGE / $DISK_SPC) * 100" | bc)

    echo "$TIMESTAMP - Memory: $MEM_PERCENT% - CPU Utilization: $CPU_UTIL_PERC - Disk Usage: $DISK_USG_PERC%" >> $LOG_FILE
    sleep 1
done
