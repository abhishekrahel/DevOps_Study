# AI Terraform Security Assessment

## Overview

This project demonstrates an AI-assisted Terraform security assessment integrated into a GitHub Actions CI/CD pipeline.

The workflow:

1. Validates Terraform configuration.
2. Runs tfsec against the Terraform code.
3. Captures tfsec results in JSON format.
4. Combines the security scan results with an AI analysis prompt.
5. Sends the prompt to the OpenAI Responses API.
6. Extracts the AI-generated security assessment.
7. Publishes the assessment to the GitHub Actions Job Summary.

The objective is to make Terraform security findings easier to understand and provide actionable remediation guidance directly within the CI/CD workflow.

---

## Architecture

```text
Terraform Configuration
        |
        v
Terraform Format Check
        |
        v
Terraform Validate
        |
        v
       tfsec
        |
        v
tfsec-results.json
        |
        +----------------------+
        |                      |
        v                      v
   prompt.md              Security Results
        |                      |
        +----------+-----------+
                   |
                   v
           final-prompt.txt
                   |
                   v
          OpenAI Responses API
                   |
                   v
           ai_response.json
                   |
                   v
             jq extraction
                   |
                   v
              ai_report.md
                   |
                   v
       GitHub Actions Job Summary
