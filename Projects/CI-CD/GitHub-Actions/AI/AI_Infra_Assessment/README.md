# AI Infrastructure Assessment

## Objective

Automatically analyze Terraform infrastructure before deployment using OpenAI and generate an AI-powered infrastructure assessment in the GitHub Actions Job Summary.

---

## Workflow

Terraform Init
↓

Terraform Validate
↓

Terraform Plan
↓

Generate Infrastructure Prompt
↓

OpenAI API

↓

AI Infrastructure Assessment

↓

GitHub Job Summary

---

## Features

- Reviews Terraform infrastructure before deployment
- Summarizes planned AWS resources
- Evaluates infrastructure health
- Highlights potential security risks
- Provides architecture recommendations
- Generates deployment assessment automatically
- Publishes AI assessment directly in GitHub Actions

---

## Technologies Used

- Terraform
- GitHub Actions
- AWS
- OpenAI API
- jq
- curl

---

## Required GitHub Secrets

| Secret | Purpose |
|---------|----------|
| AWS_ACCESS_KEY_ID | AWS Authentication |
| AWS_SECRET_ACCESS_KEY | AWS Authentication |
| OPENAI_API_KEY | Generate AI Assessment |

---

## Sample AI Assessment

The workflow generates an AI summary similar to:

- Deployment Summary
- Infrastructure Health
- Security Risks
- Best Practice Recommendations

See **sample-output.md** for a complete example.

---

## Workflow Output

Below is an example of the AI-generated Infrastructure Assessment published directly in the GitHub Actions Job Summary.

![AI Infrastructure Assessment](images/infra-assessment.png)

## Example Use Cases

- Review infrastructure before deployment
- Detect configuration risks
- Improve Terraform best practices
- Generate deployment documentation automatically
- Assist DevOps engineers during code reviews

---

## Repository

```
AI
└── AI_Infra_Assessment
    ├── AI Infrastructure Assessment.yml
    ├── README.md
    └── sample-output.md
```
