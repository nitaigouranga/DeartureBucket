resource "aws_iam_policy" "policy" {
  name        = "S3bucketpolicy"
  description = "My test policy"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::myproject-uploads2019-test-new"
    },
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource":"arn:aws:s3:::myproject-uploads2019-test-new/*"
    }
  ]

}
EOT
}