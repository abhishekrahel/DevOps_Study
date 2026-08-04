🤖 AI Terraform Security Assessment
AI Terraform Security Analysis (tfsec results)
Security Status
tfsec reported security findings: YES — 1 finding detected.

Findings
Finding ID: AVD-AWS-0131 (aws-ec2-enable-at-rest-encryption)
Severity: HIGH
Affected Terraform resource: aws_instance.infra_by_pipeline
Security issue: Root block device is not encrypted.
Why it matters: Unencrypted EBS volumes allow data-at-rest to be read if the underlying storage is compromised or snapshots are copied. This increases the risk of data exposure and may violate regulatory or organizational encryption-at-rest requirements.
Location in repo: .../Pipelines/pipeline-test/main.tf (lines 1–24)

Notes: tfsec flagged the instance root block device only. It does not show whether additional EBS volumes, instance-store (ephemeral) volumes, or the AMI snapshot are encrypted — that information is not present in the tfsec output.
