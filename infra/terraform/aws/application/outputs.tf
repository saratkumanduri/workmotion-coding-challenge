output "lambda_execution_iam_role_arn"{ 
    value = module.demoapp.lambda_execution_iam_role_arn
}

output "restapi_id"{
    value = aws_api_gateway_rest_api.rest_api.id
}