provider "aws" {
   region="us-east-1"
   access_key = "AKIARNIR6AROFUW2LDFU"
   secret_key = "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"
}
provider "aws" {
      region = "us-east-1"
      alias = "cross_account"
      assume_role{
      role_arn = "arn:aws:iam::182663769864:role/sftpmanagementaccountrole"
   }
}