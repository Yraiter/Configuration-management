# Creates new role for ec2-s3-write access
resource "aws_iam_role" "ec2-role" {
  name = "ec2--role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}
# Creates ec2 profile - to link IAM role
resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2--profile"
  role = aws_iam_role.ec2-role.name
}
# Adds IAM policy which allows ec2 instance to access s3 bucket with write permissions
resource "aws_iam_role_policy" "ec2-policy" {
  name = "ec2--policy"
  role = aws_iam_role.ec2-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

