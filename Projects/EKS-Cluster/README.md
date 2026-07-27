# Amazon EKS Cluster Deployment

## Objective

Provision an Amazon EKS cluster using Terraform and deploy a sample application using Kubernetes.

## Architecture

Terraform
↓
AWS VPC
↓
Amazon EKS
↓
Managed Node Group
↓
Kubernetes Deployment
↓
LoadBalancer Service

## Technologies

- Terraform
- AWS
- Amazon EKS
- Kubernetes
- GitHub Actions

## Folder Structure

Terraform/
Kubernetes/

## Deployment Steps

1. Provision VPC
2. Create IAM Roles
3. Create EKS Cluster
4. Create Managed Node Group
5. Configure kubectl
6. Deploy Namespace
7. Deploy Application
8. Expose Service

## Validation

kubectl get nodes

kubectl get pods

kubectl get svc

kubectl get ns

## Learning Outcomes

- Amazon EKS
- IAM Roles
- Kubernetes Networking
- Services
- Deployments
- Remote Backend
