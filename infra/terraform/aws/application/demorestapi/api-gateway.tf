module "show_vpc" {
  source = "../../modules/show-vpc"
  azs = var.vpc_azs
  vpc_tags = var.vpc_tags
  environment = var.environment
  account_prefix = var.account_prefix
}

resource "aws_security_group" "vpc_endpoint_sg" {
  name = "demorestapi"
  vpc_id = module.show_vpc.vpc_id
  ingress {
    from_port = 443
    protocol = "TCP"
    to_port = 443
    cidr_blocks = var.vpc_endpoint_access_cidrs
  }
  tags = var.default_tags
}

resource "aws_vpc_endpoint" "vpc_endpoint" {
  service_name = "com.amazonaws.${var.region}.execute-api"
  vpc_id = module.show_vpc.vpc_id
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids = module.show_vpc.private_subnets
  private_dns_enabled = true
  tags = var.default_tags
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name = "demorestapi"
  description = "Demo Restful API"
  endpoint_configuration {
    types = ["PRIVATE"]
    vpc_endpoint_ids = [aws_vpc_endpoint.vpc_endpoint.id]
  }
  tags = var.default_tags
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": "execute-api:Invoke",
        "Resource": "*"
      },
      {
        "Effect": "Deny",
        "Principal": "*",
        "Action": "execute-api:Invoke",
        "Resource": "*",
        "Condition": {
          "StringNotEquals": {
            "aws:SourceVpce": "${aws_vpc_endpoint.vpc_endpoint.id}"
          }
        }
      }
    ]
  }
 EOF
}

resource "aws_api_gateway_resource" "gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part = local.path
}

resource "aws_api_gateway_method" "gateway_method" {
  count = length(local.httpMethods)
  authorization = "NONE"
  http_method = local.httpMethods[count.index]
  resource_id = aws_api_gateway_resource.gateway_resource.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
}

resource "aws_api_gateway_deployment" "gw_deployment" {
  count = length(local.httpMethods)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name = local.stage
  variables = {
    method_id = aws_api_gateway_method.gateway_method[count.index].id
    response_id = aws_api_gateway_integration_response.integration_response[count.index].id
  }
}

resource "aws_api_gateway_method_response" "response_200" {
  count = length(local.httpMethods)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.gateway_resource.id
  http_method = aws_api_gateway_method.gateway_method[count.index].http_method
  status_code = "200"
}

resource "aws_api_gateway_integration" "restapi_integration" {
  count = length(local.httpMethods)
  http_method = aws_api_gateway_method.gateway_method[count.index].http_method
  resource_id = aws_api_gateway_resource.gateway_resource.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  integration_http_method = local.postHttpMethod
  # lambda functions can only be called with post
  type = "AWS_PROXY"
  uri = aws_lambda_function.demorestapi.invoke_arn
}

resource "aws_api_gateway_integration_response" "integration_response" {
  count = length(local.httpMethods)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.gateway_resource.id
  http_method = aws_api_gateway_method.gateway_method[count.index].http_method
  status_code = aws_api_gateway_method_response.response_200[count.index].status_code
  depends_on = [aws_api_gateway_integration.restapi_integration]
}