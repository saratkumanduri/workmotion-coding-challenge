resource "aws_lambda_permission" "api_gw_lambda" {
  count = length(local.httpMethods)
  statement_id = "AllowExecutionFromAPIGateway-${count.index}"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.demorestapi.function_name
  principal = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.identity.account_id}:${aws_api_gateway_rest_api.rest_api.id}/*/${aws_api_gateway_method.gateway_method[count.index].http_method}${aws_api_gateway_resource.gateway_resource.path}"
}

data "archive_file" "demorestapi_zip" {
  source_file = "${path.module}/lambda/demorestapi.py"
  output_path = "${path.module}/lambda/demorestapi.zip"
  type = "zip"
}

resource aws_lambda_function demorestapi {
  filename = data.archive_file.demorestapi_zip.output_path // zipfile containing the function code
  source_code_hash = filebase64sha256(data.archive_file.demorestapi_zip.output_path)
  function_name = "demorestapi"
  handler = "demorestapi.lambda_handler"
  role = aws_iam_role.demorestapi_lambda_iam_role.arn
  runtime = "python3.8"
  timeout = 1
  tags = var.default_tags
}

resource "aws_iam_role" "demorestapi_lambda_iam_role" {
  name = "iam_for_lambda"
  assume_role_policy = file("${path.module}/config/lambda-assumerole-policy.json")
  tags = var.default_tags
}

resource "aws_iam_role_policy_attachment" "lambda" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.demorestapi_lambda_iam_role.id
}