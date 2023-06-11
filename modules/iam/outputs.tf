output "ec2_iam_role" {
  value = aws_iam_role.iam_role.arn
}

output "aws_iam_instance_profile" {
  value = aws_iam_instance_profile.instance_profile.name
}
