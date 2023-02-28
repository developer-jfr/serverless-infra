resource "aws_api_gateway_rest_api" "serverless_api" {
  name        = "serverless-api"
  description = "This is my API for demonstration purposes"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


# health 
resource "aws_api_gateway_resource" "resource_health" {
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
  parent_id   = aws_api_gateway_rest_api.serverless_api.root_resource_id
  path_part   = "health"
}

resource "aws_api_gateway_method" "get_health_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
  resource_id   = aws_api_gateway_resource.resource_health.id
  http_method   = "GET"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "health_integretion" {
  rest_api_id             = aws_api_gateway_rest_api.serverless_api.id
  resource_id             = aws_api_gateway_resource.resource_health.id
  http_method             = aws_api_gateway_method.get_health_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.hello.invoke_arn
}


# products
resource "aws_api_gateway_resource" "products_resource" {
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
  parent_id   = aws_api_gateway_rest_api.serverless_api.root_resource_id
  path_part   = "products"
}



resource "aws_api_gateway_method" "get_products_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
  resource_id   = aws_api_gateway_resource.products_resource.id
  http_method   = "GET"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "products_integretion" {
  rest_api_id             = aws_api_gateway_rest_api.serverless_api.id
  resource_id             = aws_api_gateway_resource.products_resource.id
  http_method             = aws_api_gateway_method.get_products_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.hello.invoke_arn
}


# product
resource "aws_api_gateway_resource" "product_resource" {
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
  parent_id   = aws_api_gateway_rest_api.serverless_api.root_resource_id
  path_part   = "product"
}



resource "aws_api_gateway_method" "get_product_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
  resource_id   = aws_api_gateway_resource.product_resource.id
  http_method   = "GET"
  authorization = "NONE"
}


resource "aws_api_gateway_method" "post_product_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
  resource_id   = aws_api_gateway_resource.product_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "patch_product_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
  resource_id   = aws_api_gateway_resource.product_resource.id
  http_method   = "PATCH"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "delete_product_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
  resource_id   = aws_api_gateway_resource.product_resource.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "product_integretion" {
  for_each                = toset(local.product_ids)
  rest_api_id             = aws_api_gateway_rest_api.serverless_api.id
  resource_id             = aws_api_gateway_resource.product_resource.id
  http_method             = each.value
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.hello.invoke_arn
}



resource "aws_cloudwatch_log_group" "main_api_gw" {
  name = "/aws/api-gw/${aws_api_gateway_rest_api.serverless_api.name}"

  retention_in_days = 14
}

resource "aws_api_gateway_deployment" "final_deployment" {
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.serverless_api.body))
  }
}

resource "aws_api_gateway_stage" "prod_stage" {
  deployment_id = aws_api_gateway_deployment.final_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
  stage_name    = "prod_stage"
  depends_on = [
    aws_api_gateway_deployment.final_deployment
  ]
}
