resource "aws_default_vpc" "default_vpc" {
}

# Provide references to your default subnets
resource "aws_default_subnet" "default_subnet_d" {
  # Use your own region here but reference to subnet 1a
  availability_zone = "us-east-1b"
}

resource "aws_default_subnet" "default_subnet_f" {
  # Use your own region here but reference to subnet 1b
  availability_zone = "us-east-1c"
}