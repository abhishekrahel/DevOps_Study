# AI Infrastructure Failure Analysis

## Objective

Automatically analyze failed Terraform infrastructure deployments using GitHub Actions and OpenAI. The workflow captures Terraform errors, generates an AI-powered root cause analysis, and publishes the results directly in the GitHub Actions Job Summary.

---

## Workflow

```
Terraform Apply
      │
      ▼
Deployment Failure
      │
      ▼
terraform_error.log
      │
      ▼
Generate AI Prompt
      │
      ▼
OpenAI API
      │
      ▼
AI Root Cause Analysis
      │
      ▼
GitHub Actions Job Summary
```

---

## Features

- Detects failed Terraform deployments automatically
- Captures Terraform error logs
- Generates an AI prompt from the failure
- Sends the prompt to the OpenAI API
- Produces:
  - Root Cause Analysis
  - Failure Explanation
  - Recommended Fixes
  - Verification Commands
- Publishes the AI analysis directly in the GitHub Actions Job Summary

---

## Technologies Used

- GitHub Actions
- Terraform
- AWS
- OpenAI API
- Bash
- jq

---

## Sample Output

A text version of the generated AI report is available in:

- `sample-output.md`

---

## Workflow Output

Example of the AI-generated Infrastructure Failure Analysis.

![Infrastructure Failure Analysis](images/infra-failure-analysis.png)
