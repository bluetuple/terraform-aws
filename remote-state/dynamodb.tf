
# key-value store dynamodb declaration
resource "aws_dynamodb_table" "sbx_dynamodb" {
  name         = var.sbx_dynamodb
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

}
