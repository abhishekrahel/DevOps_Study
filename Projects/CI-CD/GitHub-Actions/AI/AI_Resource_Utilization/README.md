# 🤖 AI-Assisted AWS EC2 Resource Utilization Analysis

## 📌 Overview

This project demonstrates an **AI-assisted AWS resource utilization analysis workflow** using **GitHub Actions, AWS CloudWatch, AWS CLI, Bash scripting, and OpenAI API**.

The workflow collects EC2 resource utilization data from Amazon CloudWatch, generates a summarized utilization report, provides the data to an AI model for analysis, and publishes the resulting recommendations directly into the **GitHub Actions Job Summary**.

The objective is to demonstrate how AI can assist DevOps and Cloud engineers in identifying **resource utilization patterns, potential rightsizing opportunities, and areas requiring additional monitoring**.

---

## 🎯 Objectives

The workflow is designed to:

* Discover running EC2 instances based on AWS tags.
* Collect EC2 utilization metrics from CloudWatch.
* Analyze CPU utilization.
* Analyze Network In and Network Out utilization.
* Generate a human-readable utilization summary.
* Build an AI analysis prompt dynamically from the latest utilization data.
* Send the prompt to the OpenAI API.
* Extract the AI-generated assessment from the API response.
* Publish the assessment as a GitHub Actions Job Summary.
* Provide practical DevOps/Cloud recommendations without making unsupported rightsizing decisions.

---

## 🏗️ Solution Architecture

```text
                         GitHub Repository
                                │
                                ▼
                     GitHub Actions Workflow
                                │
                                ▼
                    Configure AWS Credentials
                                │
                                ▼
                 collect_utilization_data.sh
                                │
                                ▼
                         AWS EC2
                                │
                                ▼
                       Amazon CloudWatch
                                │
              ┌─────────────────┼─────────────────┐
              │                 │                 │
              ▼                 ▼                 ▼
         CPUUtilization     NetworkIn       NetworkOut
              │                 │                 │
              └─────────────────┼─────────────────┘
                                ▼
                    utilization-data.txt
                                │
                                ▼
                   utilization-summary.txt
                                │
                                ▼
                    prompts/prompt.md
                                │
                                ▼
                      final-prompt.txt
                                │
                                ▼
                         OpenAI API
                                │
                                ▼
                       ai_response.json
                                │
                                ▼
                 jq → AI Markdown Report
                                │
                                ▼
                  GitHub Actions Job Summary
```

---

## 🔄 Workflow Process

### 1. Checkout Repository

GitHub Actions checks out the repository containing the workflow, Bash script, prompt, and supporting files.

### 2. Configure AWS Credentials

The workflow configures AWS credentials using GitHub repository secrets.

The AWS CLI is then used to communicate with EC2 and CloudWatch.

### 3. Discover Running EC2 Instances

The Bash script identifies running EC2 instances using the appropriate AWS tag.

The workflow processes each discovered instance individually.

### 4. Collect CloudWatch Metrics

For each instance, the script collects:

* `CPUUtilization`
* `NetworkIn`
* `NetworkOut`

The metrics are collected using the AWS CLI `cloudwatch get-metric-statistics` command.

### 5. Generate Raw Utilization Data

The collected information is stored in:

```text
scripts/utilization-data.txt
```

This contains the individual CloudWatch datapoints for the analyzed instances.

### 6. Generate Utilization Summary

The script calculates:

* CPU Average
* CPU Minimum
* CPU Maximum
* Network In Average
* Network In Minimum
* Network In Maximum
* Network Out Average
* Network Out Minimum
* Network Out Maximum

The summarized information is written to:

```text
scripts/utilization-summary.txt
```

Example:

```text
Instance ID: i-00547f7b8087f997f
Instance Type: t3.micro

CPU Utilization Summary:
Average : 0.17%
Minimum : 0.17%
Maximum : 0.17%

Network In Summary:
Average : 0.00 bytes
Minimum : 0.00 bytes
Maximum : 0.00 bytes

Network Out Summary:
Average : 0.00 bytes
Minimum : 0.00 bytes
Maximum : 0.00 bytes
```

---

## 🧠 AI-Assisted Analysis

The workflow uses a dedicated prompt:

```text
prompts/prompt.md
```

The prompt instructs the AI to act as a **Senior Cloud/DevOps Engineer** and analyze the utilization summary.

The AI is asked to evaluate:

* EC2 resource overview
* CPU utilization
* Network utilization
* Potential resource optimization
* Rightsizing considerations
* Monitoring recommendations
* Overall assessment

### AI Safety / Accuracy Guidelines

The prompt explicitly instructs the AI to:

* Base conclusions only on supplied utilization data.
* Avoid inventing missing metrics.
* Avoid declaring an instance oversized based solely on low CPU.
* Consider the observation period.
* Identify missing information.
* Recommend additional monitoring where necessary.
* Distinguish observed facts from recommendations.
* Avoid claiming that infrastructure is completely optimized.

This helps prevent the AI from turning limited monitoring data into unsupported infrastructure recommendations.

---

## 📝 Dynamic Prompt Generation

The workflow combines the reusable AI instructions with the latest utilization summary.

The process is:

```text
prompts/prompt.md
        +
scripts/utilization-summary.txt
        ↓
final-prompt.txt
```

The placeholder:

```text
::UTILIZATION_DATA::
```

is replaced with the latest utilization summary generated during the workflow execution.

This ensures that the AI analysis is based on **fresh CloudWatch data from the current workflow run**.

---

## 🤖 OpenAI API Integration

The generated `final-prompt.txt` is sent to the OpenAI API.

The API response is initially stored as:

```text
ai_response.json
```

The raw API response contains both the AI-generated content and API metadata.

The workflow therefore extracts only the generated report.

---

## 📄 AI Report Extraction

`jq` is used to extract the Markdown report from the OpenAI response:

```bash
jq -r '
  .output[]
  | select(.type=="message")
  | .content[]
  | select(.type=="output_text")
  | .text
' ai_response.json > ai_resource_utilization_report.md
```

The resulting report is:

```text
ai_resource_utilization_report.md
```

This keeps API metadata such as token usage and response metadata out of the final user-facing report.

---

## 📊 GitHub Actions Job Summary

The extracted AI report is published using:

```bash
cat ai_resource_utilization_report.md >> "$GITHUB_STEP_SUMMARY"
```

This makes the final analysis available directly in the GitHub Actions workflow summary.

Example report sections include:

### Resource Overview

Identifies the number of EC2 instances and instance types analyzed.

### CPU Utilization Analysis

Reports:

* Average CPU
* Minimum CPU
* Maximum CPU
* Utilization classification

### Network Utilization Analysis

Reports:

* Network In
* Network Out
* Observed traffic levels

### Resource Optimization Assessment

Identifies potential optimization opportunities while avoiding unsupported conclusions.

### Monitoring Recommendations

Identifies additional metrics and longer observation periods that may be required before making infrastructure decisions.

---

## 📁 Repository Structure

```text
AI_Resource_Utilization/
│
├── README.md
│
├── ai-resource-utilization.yml
│
├── prompts/
│   └── prompt.md
│
└── scripts/
    ├── collect_utilization_data.sh
    └── utilization-summary.txt
```

During a GitHub Actions execution, additional runtime files are generated, including:

```text
utilization-data.txt
final-prompt.txt
ai_response.json
ai_resource_utilization_report.md
```

These are workflow-generated artifacts rather than the core project configuration.

---

## 🔐 Security Considerations

AWS credentials are not hardcoded in the workflow.

The workflow uses GitHub repository secrets:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

The OpenAI API key is also supplied through a GitHub secret.

Sensitive credentials should never be committed to the repository.

---

## 🧪 Testing and Validation

The workflow was tested against running EC2 instances.

The validation included:

1. Discovering running EC2 instances.
2. Confirming instance types.
3. Collecting CloudWatch CPU metrics.
4. Collecting Network In/Out metrics.
5. Generating utilization data.
6. Generating the utilization summary.
7. Creating the final AI prompt.
8. Sending the prompt to the OpenAI API.
9. Extracting the AI-generated report.
10. Publishing the report to the GitHub Actions Job Summary.

Example utilization analysis identified very low CPU utilization and no measurable Network In/Out traffic during the supplied observation period.

The AI correctly identified that the available information was insufficient to make a definitive rightsizing decision.

---

## 📸 Sample AI Output

The workflow publishes the AI-generated resource utilization assessment directly to the GitHub Actions Job Summary.

![AI Resource Utilization Assessment](images/ai-resource-utilization-summary.png)

## ⚠️ Limitations

The analysis should not be treated as a complete infrastructure optimization solution.

The current workflow does not collect:

* Memory utilization
* EBS utilization
* Disk I/O
* Application-level metrics
* Process-level metrics
* Detailed workload characteristics
* Business-criticality information

Therefore, low CPU utilization alone should **not** automatically result in an EC2 resize or termination recommendation.

Longer observation periods and additional CloudWatch metrics should be considered before making production rightsizing decisions.

---

## 🚀 Future Enhancements

Potential enhancements include:

* Add longer CloudWatch observation periods.
* Add EBS read/write metrics.
* Add status check metrics.
* Add memory metrics through CloudWatch Agent.
* Compare utilization against predefined thresholds.
* Add automated rightsizing recommendations.
* Generate cost impact estimates.
* Integrate AWS Compute Optimizer.
* Add scheduled workflow execution.
* Store historical utilization data.
* Generate utilization trend charts.
* Add automated alerts for consistently underutilized resources.

---

## 🛠️ Technologies Used

| Technology         | Purpose                            |
| ------------------ | ---------------------------------- |
| GitHub Actions     | CI/CD workflow automation          |
| AWS EC2            | Compute resources being analyzed   |
| Amazon CloudWatch  | Resource utilization metrics       |
| AWS CLI            | AWS resource and metric collection |
| Bash               | Data collection and processing     |
| `awk`              | Utilization calculations           |
| `jq`               | OpenAI response parsing            |
| OpenAI API         | AI-assisted resource analysis      |
| GitHub Job Summary | AI report visualization            |

---

## 💡 DevOps Skills Demonstrated

This project demonstrates practical experience with:

* GitHub Actions
* AWS EC2
* AWS CloudWatch
* AWS CLI
* Bash scripting
* Infrastructure monitoring
* Resource utilization analysis
* Cloud rightsizing concepts
* CI/CD automation
* API integration
* JSON processing with `jq`
* AI-assisted DevOps workflows
* Prompt engineering
* Security-conscious secret management
* Automated reporting
* Cloud cost/resource optimization

---

## 🎯 Project Outcome

This project demonstrates how a DevOps engineer can combine **AWS monitoring data, automation, CI/CD, scripting, and AI** to create an automated resource utilization assessment workflow.

Instead of manually reviewing CloudWatch metrics, the workflow automatically:

```text
Collect → Summarize → Analyze → Recommend → Report
```

This provides a practical foundation for building more advanced **AI-assisted Cloud Operations and FinOps capabilities**.

