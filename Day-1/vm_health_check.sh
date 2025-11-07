#!/bin/bash

THRESHOLD=60
EXPLAIN=0

if [[ "$1" == "explain" ]]; then
    EXPLAIN=1
fi

# CPU Utilization (average over 1 minute)
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk -F',' '{for(i=1;i<=NF;i++) if($i ~ /id/) print $i}' | awk '{print $1}' | sed 's/id//;s/%//;s/ //g')
if [[ -z "$CPU_IDLE" ]]; then
    CPU_USED=0
else
    CPU_USED=$(echo "100 - $CPU_IDLE" | bc)
fi

# Memory Utilization
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_USED_PCT=$(echo "scale=2; $MEM_USED/$MEM_TOTAL*100" | bc)

# Disk Utilization (root partition)
DISK_USED_PCT=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

HEALTHY=1
REASONS=()

if (( $(echo "$CPU_USED > $THRESHOLD" | bc -l) )); then
    HEALTHY=0
    REASONS+=("CPU usage is ${CPU_USED}% (> $THRESHOLD%)")
fi

if (( $(echo "$MEM_USED_PCT > $THRESHOLD" | bc -l) )); then
    HEALTHY=0
    REASONS+=("Memory usage is ${MEM_USED_PCT}% (> $THRESHOLD%)")
fi

if (( $DISK_USED_PCT > $THRESHOLD )); then
    HEALTHY=0
    REASONS+=("Disk usage is ${DISK_USED_PCT}% (> $THRESHOLD%)")
fi

if [[ $HEALTHY -eq 1 ]]; then
    echo "Healthy"
    if [[ $EXPLAIN -eq 1 ]]; then
        echo "All resources are below $THRESHOLD% utilization."
        echo "CPU: ${CPU_USED}% | Memory: ${MEM_USED_PCT}% | Disk: ${DISK_USED_PCT}%"
    fi
else
    echo "Not healthy"
    if [[ $EXPLAIN -eq 1 ]]; then
        for reason in "${REASONS[@]}"; do
            echo "$reason"
        done
        echo "CPU: ${CPU_USED}% | Memory: ${MEM_USED_PCT}% | Disk: ${DISK_USED_PCT}%"
    fi
fi