locals {
  product_ids = [
    aws_api_gateway_method.get_product_method.http_method,
    aws_api_gateway_method.post_product_method.http_method,
    aws_api_gateway_method.patch_product_method.http_method,
    aws_api_gateway_method.delete_product_method.http_method
  ]
}