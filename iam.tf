# aws_caller_identity: get all informations of AWS account which is running
data "aws_caller_identity" "current" {}


# local variable, assign principal_arns 
locals {
  principal_arns = var.principal_arns != null ? var.principal_arns : [data.aws_caller_identity.current.arn]
}

# aws_iam_policy_document: define our policy, and assign it to aws_iam_policy and aws_iam_role
data "aws_iam_policy_document" "policy_doc" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.s3_bucket.arn]
  }

  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.s3_bucket.arn}/*"]
  }

  statement {
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
    resources = [aws_dynamodb_table.dynamodb_table.arn]
  }
}

#
resource "aws_iam_policy" "policy" {
  name   = "${title(var.project)}S3BackendPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.policy_doc.json
}

resource "aws_iam_role" "iam_role" {
  name = "${title(var.project)}S3BackendRole"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
        "AWS": ${jsonencode(local.principal_arns)}
      },
      "Effect": "Allow"
      }
    ]
  }
  EOF

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.policy.arn
}
