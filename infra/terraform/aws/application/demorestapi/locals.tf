locals {
  stage= var.environment
  postHttpMethod="POST"
  getHttpMethod = "GET"
  httpMethods = ["GET", "POST"]
  path="demorestapi"
}