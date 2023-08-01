provider "aws" {
   region="us-east-1"
   }
provider "aws" {
      region = "us-east-1"
       assume_role{
      role_arn = "arn:aws:iam::182663769864:role/sftpmanagementaccountrole"
   }
}