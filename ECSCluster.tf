resource "aws_ecs_cluster" "demo-ecs-cluster-test" {
  name = "ecs-cluster-Anitha-test"
}

resource "aws_ecs_service" "demo-ecs-service-test" {
  name            = "demo-app-test"
 //newcode
 enable_execute_command = "true"
  cluster         = aws_ecs_cluster.demo-ecs-cluster-test.id
  task_definition = aws_ecs_task_definition.demo-ecs-task-definition-test.arn
  launch_type     = "FARGATE"
  platform_version = "LATEST"
  network_configuration {
    
 subnets          = ["${aws_default_subnet.default_subnet_d.id}", "${aws_default_subnet.default_subnet_f.id}"]
    assign_public_ip = true     # Provide the containers with public IPs
  }
  desired_count = 1
}

resource "aws_ecs_task_definition" "demo-ecs-task-definition-test" {
  
  family                   = "ecs-task-definition-demo-test"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "1024"
  cpu                      = "512"
 
 task_role_arn = "arn:aws:iam::097211253852:role/testcrossaccountrolenew"
execution_role_arn       = "${aws_iam_role.cross_account.arn}"

  container_definitions    = <<EOF
[
  {
    "name": "demo-container-test",
       
  "image": "097211253852.dkr.ecr.us-east-1.amazonaws.com/apache-repo",
    "memory": 1024,
    "cpu": 512,
    "essential": true,
       
    "portMappings": [
      {
        "containerPort": 80,
          "hostPort": 80
          
      }
    ],
       "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "example-production-client",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "streaming"
      }
      }
  }
]

  EOF
}




resource "aws_iam_role" "ecsTaskExecutionRole-test" {
 name               = "TaskExecutionRoletest"

 assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy_test.json}"
}

# generates an iam policy document in json format for the ecs task execution role
data "aws_iam_policy_document" "assume_role_policy_test" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
   
   
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
      
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy_test" {
  role       = "${aws_iam_role.ecsTaskExecutionRole-test.name}"
 
 policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

 