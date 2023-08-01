resource "aws_cloudwatch_event_rule" "uploads_test" {
  name        = "myproject-capture-uploads-test"
  description = "Capture S3 events on uploads bucket"
  event_pattern = <<PATTERN
{
  
 
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "PutObject","CompleteMultipartUpload"
    ],
     
    
  
    
     "requestParameters": {
      "bucketName": ["${aws_s3_bucket.uploads_test.id}"]
    
    }
  }
}
PATTERN
}
resource "aws_cloudwatch_event_target" "uploads_test" {
  target_id = "myproject-process-uploads-test"
  arn       = "${aws_ecs_cluster.demo-ecs-cluster-test.arn}"
  rule      = "${aws_cloudwatch_event_rule.uploads_test.name}"
  role_arn  = "${aws_iam_role.uploads_events_test.arn}"
  ecs_target {
    launch_type = "FARGATE"
    platform_version = "LATEST"
    task_count          = 1 # Launch one container / event
    task_definition_arn = "${aws_ecs_task_definition.demo-ecs-task-definition-test.arn}"
     enable_execute_command = true
    
   
    network_configuration  {
    
      subnets         = var.vpc_subnet_ids
      assign_public_ip= true
      
      }
}
  
  

 input_transformer  {
    
   input_paths = {
     s3_bucket = "$.detail.requestParameters.bucketName"
     s3_key    = "$.detail.requestParameters.key"
   }
  
    input_template = <<TEMPLATE
{
  "containerOverrides": [
   {
     "name": "demo-container-test",
      "environment": [
       { "name": "S3_BUCKET", "value": <s3_bucket> },
       { "name": "S3_KEY", "value": <s3_key> }
      ]
    }
  ]
 
 
}
TEMPLATE
  }
}



resource "aws_iam_role" "uploads_events_test" {
  name = "myproject-uploads-events-test"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
resource "aws_iam_role_policy" "ecs_events_run_task_with_new_role" {
  name = "myproject-uploads-run-task-with-new-role-test"
  role = "${aws_iam_role.uploads_events_test.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ecs:RunTask",
       
    "Resource": "${replace(aws_ecs_task_definition.demo-ecs-task-definition-test.arn, "/:\\d+$/", ":*")}"
   }
  ]
}
POLICY
}

