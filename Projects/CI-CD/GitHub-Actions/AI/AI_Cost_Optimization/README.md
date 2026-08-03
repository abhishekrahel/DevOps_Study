# AI AWS Cost Optimization

## Objective

This GitHub Actions workflow uses AWS CLI to collect an inventory of provisioned AWS infrastructure and sends the collected data to an AI model for cost optimization analysis.

The AI identifies potential cost drivers, optimization opportunities, best practices, and limitations based strictly on the infrastructure inventory provided.

## Workflow

Terraform Apply
        ↓
AWS Infrastructure
        ↓
AWS CLI Cost/Infrastructure Data Collection
        ↓
cost-data.txt
        ↓
AI Prompt + Infrastructure Inventory
        ↓
OpenAI API
        ↓
AI Cost Optimization Report
        ↓
GitHub Actions Job Summary

## Infrastructure Data Collected

The workflow collects information about provisioned AWS resources such as:

- EC2 instances
- EBS volumes
- EKS clusters and node groups
- Auto Scaling Groups
- NAT Gateways
- Elastic IPs
- Load Balancers

## AI Analysis

The AI-generated report provides:

- Infrastructure Summary
- Primary Cost Drivers
- Cost Optimization Recommendations
- High / Medium / Low Impact Opportunities
- AWS Best Practices
- Estimated Cost Saving Opportunities
- Missing or Incomplete Information
- Confidence Level

## Important Limitation

The current implementation analyzes infrastructure inventory rather than actual AWS billing data.

The analysis does not currently include:

- AWS Cost Explorer billing data
- CPU / memory utilization
- Network and data-transfer usage
- EBS utilization
- CloudWatch metrics
- Detailed resource-to-workload mapping

Therefore, the workflow provides qualitative cost optimization recommendations rather than specific dollar savings.

## Workflow Output

Below is an example of the AI-generated Cost Optimization Report published directly in the GitHub Actions Job Summary.

![AI Cost Optimization Report](images/ai-cost-optimization.png)

## Artifacts

The workflow uploads the following diagnostic data as a GitHub Actions artifact:

- `cost-data.txt`
- `final-prompt.txt`
- AI analysis output

## Future Enhancements

Possible future improvements include:

- Integrate AWS Cost Explorer data
- Integrate CloudWatch utilization metrics
- Identify idle and underutilized resources
- Estimate potential dollar savings
- Add automated cost optimization recommendations
- Add scheduled cost analysis

## Key Learning

This project demonstrates how AI can be integrated into a DevOps pipeline to analyze AWS infrastructure and provide actionable cost optimization recommendations while keeping the analysis grounded in collected infrastructure data.
