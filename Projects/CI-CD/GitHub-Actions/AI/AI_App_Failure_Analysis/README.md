# AI Application Failure Analysis

## Overview

This project demonstrates an AI-assisted GitHub Actions workflow that automatically detects Kubernetes application deployment failures, collects cluster diagnostics, and generates an AI-powered root cause analysis using the OpenAI API.

Instead of manually investigating failed deployments, the workflow gathers deployment information, pod status, events, logs, and rollout details, then provides a structured incident report with probable root cause, supporting evidence, recommended resolution steps, verification commands, and confidence level.

---

## Technologies Used

- GitHub Actions
- AWS EKS
- Kubernetes
- Docker
- Amazon ECR
- OpenAI API
- Bash
- kubectl
- jq

---

## Workflow

1. Deploy application to Amazon EKS.
2. Detect deployment failure during rollout.
3. Collect Kubernetes diagnostics automatically.
4. Generate AI prompt containing deployment diagnostics.
5. Send diagnostics to OpenAI API.
6. Generate AI-powered failure analysis.
7. Publish AI incident report to the GitHub Actions Job Summary.

---

## Kubernetes Diagnostics Collected

The workflow automatically gathers:

- Cluster Information
- Deployment Rollout Status
- Deployment Description
- ReplicaSets
- Node Status
- Pod Status
- Failed Pod Description
- Pod Logs
- Kubernetes Events

These diagnostics are consolidated into a single `failure-data.txt` file before being analyzed by AI.

---

## AI Analysis Includes

The AI-generated report provides:

- Overall Application Status
- Root Cause Analysis
- Supporting Evidence
- Resolution Steps
- Verification Commands
- Preventive Recommendations
- Confidence Level

The analysis is generated entirely from the collected Kubernetes diagnostics without requiring manual troubleshooting.

---

## Example Failure Scenario

The demonstrated failure intentionally deploys an invalid container image:

```
Image:
449957914366.dkr.ecr.us-east-1.amazonaws.com/dev-nginx-repo:wrong-tag
```

Resulting Kubernetes status:

```
ImagePullBackOff
ProgressDeadlineExceeded
Deployment Unavailable
```

The AI correctly identifies the invalid image reference as the primary cause and recommends appropriate remediation steps.

---

## Workflow Output

Below is an example of the AI-generated Kubernetes Application Failure Analysis published directly in the GitHub Actions Job Summary.

![AI Application Failure Analysis](images/app-failure-analysis.png)

---

## Repository

GitHub Repository

https://github.com/abhishekrahel/DevOps_Study
