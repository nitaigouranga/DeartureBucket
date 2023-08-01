resource "aws_cloudwatch_log_group" "example-production-client" {
  name = "example-production-client"

  tags = {
    Environment = "production"
  }
}

resource "aws_cloudwatch_log_stream" "example-production-client" {
  name           = "example-production-client"
  log_group_name = aws_cloudwatch_log_group.example-production-client.name
}