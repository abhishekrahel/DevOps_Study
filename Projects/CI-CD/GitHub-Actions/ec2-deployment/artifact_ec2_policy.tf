resource "aws_iam_role_policy" "ec2_artifact_read" {
  name = "devops-ec2-artifact-read"
  role = aws_iam_role.app_server.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ReadDeploymentArtifact"
        Effect = "Allow"

        Action = [
          "s3:GetObject"
        ]

        Resource = "${aws_s3_bucket.deployment_artifacts.arn}/*"
      },
      {
        Sid    = "DecryptDeploymentArtifact"
        Effect = "Allow"

        Action = [
          "kms:Decrypt"
        ]

        Resource = aws_kms_key.deployment_artifacts.arn
      }
    ]
  })
}