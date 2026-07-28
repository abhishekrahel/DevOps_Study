🤖 AI Infrastructure Failure Analysis
Root Cause
The EKS managed node group create failed because the EC2 instance type(s) you supplied to the node group do not exist (or are not available) in the region / account context being used by Terraform. AWS returned Ec2InstanceTypeDoesNotExist, which caused the node group to reach CREATE_FAILED.

Why it happened
Common reasons for this error (one or more apply in your environment):

The instance type names in your Terraform config are misspelled or invalid (typo).
The instance type is not offered in the AWS region you are deploying to.
The instance type family requires a different CPU architecture (ARM/Graviton) but the node group AMI/ami_type or launch template is for x86 (or vice-versa).

Recommended Fix
Inspect the instance types configured for the node group

If you're explicitly setting instance_types in aws_eks_node_group, verify each type is correct (no typos).
If you're using a launch template, inspect the launch template for an InstanceType override.
Ensure the instance types are available in the region you're deploying to

Change to valid instance types for that region, or change the region if you intended to deploy elsewhere.

Verification Commands
Replace placeholders (<...>) with your values.

Show the node group resource in Terraform state / config
See what Terraform is trying to create:
terraform plan -var-file=<vars.tfvars>
terraform show -json | jq '.values.root_module.resources[] | select(.address=="module.eks.aws_eks_node_group.nodes")'
Inspect the node group details and error from AWS
List node groups:
aws eks list-nodegroups --cluster-name dev-eks-cluster --region
Describe the failing nodegroup (will show status and any failure reason):
aws eks describe-nodegroup --cluster-name dev-eks-cluster --nodegroup-name nodes --region
Verify the instance types exist and are offered in the region
