output "lambda_execution_iam_role_arn"{ 
    value = aws_iam_role.demorestapi_lambda_iam_role.arn
}

output "restapi_id"{
    value = aws_api_gateway_rest_api.rest_api.id
}