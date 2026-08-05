#!/bin/bash

set -e

OUTPUT_FILE="../utilization-data.txt"

echo "Collecting EC2 resource utilization..." 

echo "========================================" > "$OUTPUT_FILE"
echo "AI RESOURCE UTILIZATION - AWS EC2" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "========================================" >> "$OUTPUT_FILE"
echo "EC2 Instances" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

INSTANCE_IDS=$(aws ec2 describe-instances \
    --filters "Name=tag:Purpose,Values=AI-Resource-Utilization" \
              "Name=instance-state-name,Values=running" \
    --query "Reservations[].Instances[].InstanceId" \
    --output text)

if [ -z "$INSTANCE_IDS" ]; then
    echo "No running EC2 instances found." >> "$OUTPUT_FILE"
    exit 0
fi

echo "Instances found: $INSTANCE_IDS"

for INSTANCE_ID in $INSTANCE_IDS
do
    echo "" >> "$OUTPUT_FILE"
    echo "Instance ID: $INSTANCE_ID" >> "$OUTPUT_FILE"

    INSTANCE_TYPE=$(aws ec2 describe-instances \
        --instance-ids "$INSTANCE_ID" \
        --query "Reservations[0].Instances[0].InstanceType" \
        --output text)

    echo "Instance Type: $INSTANCE_TYPE" >> "$OUTPUT_FILE"

    echo "CPU Utilization:" >> "$OUTPUT_FILE"

    CPU_DATA=$(aws cloudwatch get-metric-statistics \
        --namespace AWS/EC2 \
        --metric-name CPUUtilization \
        --dimensions Name=InstanceId,Value="$INSTANCE_ID" \
        --statistics Average \
        --period 300 \
        --start-time "$(date -u -d '1 hour ago' '+%Y-%m-%dT%H:%M:%SZ')" \
        --end-time "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
        --region us-east-1 \
        --query "Datapoints[].[Timestamp,Average]" \
        --output text | sort  | tr -d '\r')

    if [ -z "$CPU_DATA" ]; then
    echo "No CPU datapoints available." >> "$OUTPUT_FILE"
else
    while read -r TIMESTAMP VALUE
    do
        printf "%-25s : %.2f%%\n" "$TIMESTAMP" "$VALUE" >> "$OUTPUT_FILE"
    done <<< "$CPU_DATA"
fi

    echo "" >> "$OUTPUT_FILE"


    echo "Network In:" >> "$OUTPUT_FILE"

    NETWORK_IN_DATA=$(aws cloudwatch get-metric-statistics \
        --namespace AWS/EC2 \
        --metric-name NetworkIn \
        --dimensions Name=InstanceId,Value="$INSTANCE_ID" \
        --statistics Average \
        --period 300 \
        --start-time "$(date -u -d '1 hour ago' '+%Y-%m-%dT%H:%M:%SZ')" \
        --end-time "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
        --region us-east-1 \
        --query "Datapoints[].[Timestamp,Average]" \
        --output text | sort  | tr -d '\r')


     if [ -z "$NETWORK_IN_DATA" ]; then
    echo "No Network In datapoints available." >> "$OUTPUT_FILE"
else
    while read -r TIMESTAMP VALUE
    do
        printf "%-25s : %.2f bytes\n" "$TIMESTAMP" "$VALUE" >> "$OUTPUT_FILE"
    done <<< "$NETWORK_IN_DATA"
fi   

    echo "" >> "$OUTPUT_FILE"
    echo "Network Out:" >> "$OUTPUT_FILE"

    NETWORK_OUT_DATA=$(aws cloudwatch get-metric-statistics \
        --namespace AWS/EC2 \
        --metric-name NetworkOut \
        --dimensions Name=InstanceId,Value="$INSTANCE_ID" \
        --statistics Average \
        --period 300 \
        --start-time "$(date -u -d '1 hour ago' '+%Y-%m-%dT%H:%M:%SZ')" \
        --end-time "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
        --region us-east-1 \
        --query "Datapoints[].[Timestamp,Average]" \
        --output text | sort  | tr -d '\r')

    if [ -z "$NETWORK_OUT_DATA" ]; then
    echo "No Network Out datapoints available." >> "$OUTPUT_FILE"
else
    while read -r TIMESTAMP VALUE
    do
        printf "%-25s : %.2f bytes\n" "$TIMESTAMP" "$VALUE" >> "$OUTPUT_FILE"
    done <<< "$NETWORK_OUT_DATA"
fi

done

echo "" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "Collection completed." >> "$OUTPUT_FILE"

echo "Utilization data collected successfully."

echo "========================================" > utilization-summary.txt
echo "AI RESOURCE UTILIZATION - SUMMARY" >> utilization-summary.txt
echo "========================================" >> utilization-summary.txt
echo "Generated on: $(date)" >> utilization-summary.txt
echo "" >> utilization-summary.txt

echo "========================================" >> utilization-summary.txt
echo "EC2 Resource Utilization Summary" >> utilization-summary.txt
echo "========================================" >> utilization-summary.txt
echo "" >> utilization-summary.txt

for INSTANCE_ID in "${INSTANCE_IDS[@]}"
do

    INSTANCE_TYPE=$(aws ec2 describe-instances \
        --instance-ids "$INSTANCE_ID" \
        --region us-east-1 \
        --query "Reservations[0].Instances[0].InstanceType" \
        --output text)

    echo "Instance ID: $INSTANCE_ID" >> utilization-summary.txt
    echo "Instance Type: $INSTANCE_TYPE" >> utilization-summary.txt
    echo "" >> utilization-summary.txt

    # CPU Utilization
    CPU_DATA=$(aws cloudwatch get-metric-statistics \
        --namespace AWS/EC2 \
        --metric-name CPUUtilization \
        --dimensions Name=InstanceId,Value="$INSTANCE_ID" \
        --statistics Average \
        --period 300 \
        --start-time "$(date -u -d '1 hour ago' '+%Y-%m-%dT%H:%M:%SZ')" \
        --end-time "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
        --region us-east-1 \
        --query "Datapoints[].Average" \
        --output text | tr -d '\r')

    echo "CPU Utilization Summary:" >> utilization-summary.txt

    if [ -z "$CPU_DATA" ]; then
        echo "No CPU datapoints available." >> utilization-summary.txt
    else
        CPU_AVG=$(echo "$CPU_DATA" | awk '{sum+=$1} END {if(NR>0) printf "%.2f",sum/NR}')
        CPU_MIN=$(echo "$CPU_DATA" | awk 'BEGIN{min=999999} {if($1<min)min=$1} END {printf "%.2f",min}')
        CPU_MAX=$(echo "$CPU_DATA" | awk 'BEGIN{max=0} {if($1>max)max=$1} END {printf "%.2f",max}')

        echo "Average : $CPU_AVG%" >> utilization-summary.txt
        echo "Minimum : $CPU_MIN%" >> utilization-summary.txt
        echo "Maximum : $CPU_MAX%" >> utilization-summary.txt
    fi

    echo "" >> utilization-summary.txt

    # Network In
    NETWORK_IN_DATA=$(aws cloudwatch get-metric-statistics \
        --namespace AWS/EC2 \
        --metric-name NetworkIn \
        --dimensions Name=InstanceId,Value="$INSTANCE_ID" \
        --statistics Average \
        --period 300 \
        --start-time "$(date -u -d '1 hour ago' '+%Y-%m-%dT%H:%M:%SZ')" \
        --end-time "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
        --region us-east-1 \
        --query "Datapoints[].Average" \
        --output text | tr -d '\r')

    echo "Network In Summary:" >> utilization-summary.txt

    if [ -z "$NETWORK_IN_DATA" ]; then
        echo "No Network In datapoints available." >> utilization-summary.txt
    else
        NETWORK_IN_AVG=$(echo "$NETWORK_IN_DATA" | awk '{sum+=$1} END {printf "%.2f",sum/NR}')
        NETWORK_IN_MIN=$(echo "$NETWORK_IN_DATA" | awk 'BEGIN{min=999999999999} {if($1<min)min=$1} END {printf "%.2f",min}')
        NETWORK_IN_MAX=$(echo "$NETWORK_IN_DATA" | awk 'BEGIN{max=0} {if($1>max)max=$1} END {printf "%.2f",max}')

        echo "Average : $NETWORK_IN_AVG bytes" >> utilization-summary.txt
        echo "Minimum : $NETWORK_IN_MIN bytes" >> utilization-summary.txt
        echo "Maximum : $NETWORK_IN_MAX bytes" >> utilization-summary.txt
    fi

    echo "" >> utilization-summary.txt

    # Network Out
    NETWORK_OUT_DATA=$(aws cloudwatch get-metric-statistics \
        --namespace AWS/EC2 \
        --metric-name NetworkOut \
        --dimensions Name=InstanceId,Value="$INSTANCE_ID" \
        --statistics Average \
        --period 300 \
        --start-time "$(date -u -d '1 hour ago' '+%Y-%m-%dT%H:%M:%SZ')" \
        --end-time "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
        --region us-east-1 \
        --query "Datapoints[].Average" \
        --output text | tr -d '\r')

    echo "Network Out Summary:" >> utilization-summary.txt

    if [ -z "$NETWORK_OUT_DATA" ]; then
        echo "No Network Out datapoints available." >> utilization-summary.txt
    else
        NETWORK_OUT_AVG=$(echo "$NETWORK_OUT_DATA" | awk '{sum+=$1} END {printf "%.2f",sum/NR}')
        NETWORK_OUT_MIN=$(echo "$NETWORK_OUT_DATA" | awk 'BEGIN{min=999999999999} {if($1<min)min=$1} END {printf "%.2f",min}')
        NETWORK_OUT_MAX=$(echo "$NETWORK_OUT_DATA" | awk 'BEGIN{max=0} {if($1>max)max=$1} END {printf "%.2f",max}')

        echo "Average : $NETWORK_OUT_AVG bytes" >> utilization-summary.txt
        echo "Minimum : $NETWORK_OUT_MIN bytes" >> utilization-summary.txt
        echo "Maximum : $NETWORK_OUT_MAX bytes" >> utilization-summary.txt
    fi

    echo "" >> utilization-summary.txt
    echo "----------------------------------------" >> utilization-summary.txt
    echo "" >> utilization-summary.txt

done

echo "Summary generation completed." >> utilization-summary.txt
