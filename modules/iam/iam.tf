
resource "aws_iam_instance_profile" "instance_profile" {
  name = join("", [var.name, "-", "iam-instance-profile"])
  role = aws_iam_role.iam_role.id
}

resource "aws_iam_role" "iam_role" {
  name = join("", [var.name, "-", "iam-role"])

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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

  inline_policy {
    name = join("", [var.name, "-", "iam-policy"])

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = var.actions
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

  tags = var.tags

  # permissions_boundary = "arn:aws:iam::ACCOUNT_NUMBER:policy/ALBIngressControllerIAMPolicy"
}

