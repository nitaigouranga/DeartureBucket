resource "aws_s3_bucket" "uploads_test" {
  bucket = "myproject-uploads2019-test-new"


}
resource "aws_s3_bucket_notification" "name" {
  bucket = aws_s3_bucket.uploads_test.id
  eventbridge = true
}