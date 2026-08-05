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
        --output text | sort)

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
        --output text | sort)


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
        --output text | sort)

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
