#!/bin/bash

set -ex

OUTPUT_FILE="cost-data.txt"

echo "Collecting AWS infrastructure inventory..."

# Start fresh
> "$OUTPUT_FILE"

echo "=============================================================================" >> "$OUTPUT_FILE"
echo "AI AWS COST OPTIMIZATION - INFRASTRUCTURE INVENTORY" >> "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "=============================================================================" >> "$OUTPUT_FILE"

###############################################
echo "" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "AWS Account" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

aws sts get-caller-identity \
  --query "[Account,Arn]" \
  --output table >> "$OUTPUT_FILE"

###############################################
echo "" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "AWS Region" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

# aws configure get region >> "$OUTPUT_FILE"
echo "${AWS_REGION:-$AWS_DEFAULT_REGION}" >> "$OUTPUT_FILE"

###############################################
echo "" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "EC2 Instances" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,Tags[?Key=='Name'].Value|[0]]" \
  --output table >> "$OUTPUT_FILE"

###############################################
echo "" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "EBS Volumes" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

aws ec2 describe-volumes \
  --query "Volumes[*].[VolumeId,Size,VolumeType,State]" \
  --output table >> "$OUTPUT_FILE"

###############################################
echo "" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "Elastic IPs" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

aws ec2 describe-addresses \
  --query "Addresses[*].[PublicIp,AllocationId,AssociationId]" \
  --output table >> "$OUTPUT_FILE"

###############################################
echo "" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "Application Load Balancers" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

aws elbv2 describe-load-balancers \
  --query "LoadBalancers[*].[LoadBalancerName,Type,Scheme,State.Code]" \
  --output table >> "$OUTPUT_FILE"

###############################################
echo "" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "NAT Gateways" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

aws ec2 describe-nat-gateways \
  --query "NatGateways[*].[NatGatewayId,State]" \
  --output table >> "$OUTPUT_FILE"

###############################################
echo "" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "EKS Clusters" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

aws eks list-clusters \
  --output table >> "$OUTPUT_FILE"

###############################################
echo "" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "EKS Node Groups" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

CLUSTERS=$(aws eks list-clusters --query "clusters[]" --output text)

if [ -n "$CLUSTERS" ]; then
    for CLUSTER in $CLUSTERS
    do
        echo "" >> "$OUTPUT_FILE"
        echo "Cluster: $CLUSTER" >> "$OUTPUT_FILE"

        NODEGROUPS=$(aws eks list-nodegroups \
            --cluster-name "$CLUSTER" \
            --query "nodegroups[]" \
            --output text)

        if [ -n "$NODEGROUPS" ]; then
            for NODEGROUP in $NODEGROUPS
            do
                aws eks describe-nodegroup \
                  --cluster-name "$CLUSTER" \
                  --nodegroup-name "$NODEGROUP" \
                  --query "nodegroup.[nodegroupName,instanceTypes[0],scalingConfig.desiredSize,scalingConfig.minSize,scalingConfig.maxSize,status]" \
                  --output table >> "$OUTPUT_FILE"
            done
        else
            echo "No node groups found." >> "$OUTPUT_FILE"
        fi
    done
else
    echo "No EKS clusters found." >> "$OUTPUT_FILE"
fi

###############################################
echo "" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "Auto Scaling Groups" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

aws autoscaling describe-auto-scaling-groups \
  --query "AutoScalingGroups[*].[AutoScalingGroupName,DesiredCapacity,MinSize,MaxSize]" \
  --output table >> "$OUTPUT_FILE"

###############################################
echo "" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "Summary" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

echo "Infrastructure inventory collected successfully." >> "$OUTPUT_FILE"

echo ""
echo "Diagnostics successfully collected."

