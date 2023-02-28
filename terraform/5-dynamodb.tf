resource "aws_dynamodb_table" "product_inventory" {
  name           = "product-inventory-1"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "productId"

  attribute {
    name = "productId"
    type = "S"
  }

  tags = {
    Name        = "product-inventory"
    Environment = "production"
  }
}