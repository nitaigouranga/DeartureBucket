resource "aws_cloudtrail" "uploads1" {
  is_multi_region_trail = true
  name           = "hhs-logging-master-stack-rLoggingTemplate-1TKXKHQO86Z3F-rCloudTrail-KTQTYX807N2S140"
  s3_bucket_name = "logs-cloudtrail-global-097211253852-us-east-1"
  s3_key_prefix  = "uploads"
  event_selector {
    read_write_type           = "All"
    include_management_events = false
    data_resource {
      type   = "AWS::S3::Object"
      values = ["${aws_s3_bucket.uploads_test.arn}/"]
    }
  }
 }
