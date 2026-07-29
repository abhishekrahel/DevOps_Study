#!/bin/bash

NAMESPACE="qa"
DEPLOYMENT="html-app"
OUTPUT_FILE="failure-data.txt"

echo "Collecting Kubernetes diagnostics..."

# Find the first pod belonging to the deployment
POD=$(kubectl get pods -n $NAMESPACE \
  -l app=$DEPLOYMENT \
  -o jsonpath='{.items[0].metadata.name}')

{
echo "========================================"
echo "Cluster Information"
echo "========================================"
kubectl cluster-info

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
echo "Deployment"
echo "========================================"
kubectl describe deployment $DEPLOYMENT -n $NAMESPACE

echo
echo "========================================"
echo "Pod Description"
echo "========================================"
kubectl describe pod $POD -n $NAMESPACE

echo
echo "========================================"
echo "Pod Logs"
echo "========================================"
kubectl logs $POD -n $NAMESPACE

echo
echo "========================================"
echo "Events"
echo "========================================"
kubectl get events -n $NAMESPACE --sort-by=.metadata.creationTimestamp

} > "$OUTPUT_FILE"

echo
echo "Diagnostics saved to $OUTPUT_FILE"
