## Module to create an IAM ROLE for ECS Task

resource "aws_iam_role" "cross_account" {
    name = "testcrossaccountrolenew"

  assume_role_policy = jsonencode({



    "Version": "2012-10-17",
    "Statement": [
      {
          "Sid": "AllowUseOfKeyInAccount182663769864",
          "Effect": "Allow",
          
          "Principal": {
              
               "AWS": "arn:aws:iam::182663769864:root"
             
           },
          "Action" : "sts:AssumeRole"
        }, 
     
        {
          "Effect": "Allow",
          
          "Principal": {
            "Service":"ecs-tasks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
          
        }
        
      ]
       })
        
}

data "aws_iam_policy_document" "retrievesecret_policy" {
  statement {
    // sid = "Allow KMS Use"
    effect = "Allow"
    actions = ["secretsmanager:GetSecretValue",
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds",
                "kms:Decrypt",
                "s3:*",
                "s3:GetBucketLocation",
                "s3:GetEncryptionConfiguration",
                "kms:GenerateDataKey",
      "s3:GetObject",
      "s3:ListBucket",
"ssmmessages:CreateControlChannel",
"ssmmessages:CreateDataChannel",
"ssmmessages:OpenControlChannel",
"ssmmessages:OpenDataChannel",
"ecs:ExecuteCommand",
"logs:DescribeLogGroups",
"logs:CreateLogStream",
 "logs:CreateLogGroup",
                 "logs:DescribeLogStreams",
               "logs:PutLogEvents",
               "ecs:DescribeTasks"
]
    
  
    resources = ["*"]
       

 
  }
}
resource "aws_iam_policy" "crossaccount_use" {
  name        = "crossaccountuse_test1"
  description = "Policy to allow access other account"
  policy      = "${data.aws_iam_policy_document.retrievesecret_policy.json}"
}
resource "aws_iam_role_policy_attachment" "temp1" {
  role       = "${aws_iam_role.cross_account.name}"
   policy_arn = "${aws_iam_policy.crossaccount_use.arn}"
 // count      = "${length(var.iam_policy_arn)}"
 
}

resource "aws_iam_role_policy_attachment" "temp2" {
  role       = "${aws_iam_role.cross_account.name}"
   
   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
 
}
resource "aws_iam_role_policy_attachment" "temp3" {
  role       = "${aws_iam_role.cross_account.name}"
   policy_arn = "${aws_iam_policy.policy.arn}"
 
}
//teresource "aws_iam_role_policy_attachment" "temp4" {
 // role       = "${aws_iam_role.cross_account.name}"
   
  // policy_arn = "arn:aws:iam::aws:policy/service-role/CloudWatchAgentServerPolicy"
 
//}


