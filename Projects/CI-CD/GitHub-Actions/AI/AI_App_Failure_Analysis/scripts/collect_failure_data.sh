#!/bin/bash

# ==============================================================================
# AI Application Failure Analysis - Kubernetes Diagnostics Collector
# ==============================================================================

NAMESPACE="qa"
DEPLOYMENT="html-app"
OUTPUT_FILE="failure-data.txt"

echo "Collecting Kubernetes diagnostics..."

# ------------------------------------------------------------------------------
# Find the failed pod (preferred)
# ------------------------------------------------------------------------------

FAILED_POD=$(kubectl get pods -n "$NAMESPACE" --no-headers | \
grep -E "ImagePullBackOff|ErrImagePull|CrashLoopBackOff|Error|Pending|CreateContainerConfigError|CreateContainerError|RunContainerError|OOMKilled" | \
awk '{print $1}' | head -1)

# ------------------------------------------------------------------------------
# If no failed pod exists, use the first pod belonging to the deployment
# ------------------------------------------------------------------------------

if [ -z "$FAILED_POD" ]; then
    FAILED_POD=$(kubectl get pods -n "$NAMESPACE" \
        -l app="$DEPLOYMENT" \
        -o jsonpath='{.items[0].metadata.name}')
fi

{
echo "============================================================================="
echo "AI APPLICATION FAILURE ANALYSIS - KUBERNETES DIAGNOSTICS"
echo "Generated on: $(date)"
echo "============================================================================="

echo
echo "========================================"
echo "Cluster Information"
echo "========================================"
kubectl cluster-info

echo
echo "========================================"
echo "Deployment Rollout Status"
echo "========================================"
kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE || true

echo
echo "========================================"
echo "Current Deployment Image"
echo "========================================"
kubectl get deployment $DEPLOYMENT \
-n $NAMESPACE \
-o jsonpath='{.spec.template.spec.containers[*].image}'

echo

echo
echo "========================================"
echo "ReplicaSets"
echo "========================================"
kubectl get rs -n $NAMESPACE

echo
echo "========================================"
echo "ReplicaSet Details"
echo "========================================"
kubectl describe rs -n $NAMESPACE

echo
echo "========================================"
echo "Nodes"
echo "========================================"
kubectl get nodes

echo
echo "========================================"
echo "Pods"
echo "========================================"
kubectl get pods -n $NAMESPACE -o wide

echo
echo "========================================"
echo "Deployment Details"
echo "========================================"
kubectl describe deployment $DEPLOYMENT -n $NAMESPACE

echo
echo "========================================"
echo "Failed Pod"
echo "========================================"
echo "$FAILED_POD"

echo
echo "========================================"
echo "Failed Pod Description"
echo "========================================"
kubectl describe pod "$FAILED_POD" -n "$NAMESPACE"

echo
echo "========================================"
echo "Pod Logs"
echo "========================================"

if kubectl logs "$FAILED_POD" -n "$NAMESPACE" >/dev/null 2>&1
then
    kubectl logs "$FAILED_POD" -n "$NAMESPACE"
else
    echo "Container logs are unavailable."
    echo "Reason: Container never started or image could not be pulled."
fi

echo
echo "========================================"
echo "Events"
echo "========================================"
kubectl get events -n "$NAMESPACE" --sort-by=.metadata.creationTimestamp

} > "$OUTPUT_FILE"

echo
echo "Diagnostics successfully collected."
echo "Output File : $OUTPUT_FILE"
echo "Failed Pod  : $FAILED_POD"
