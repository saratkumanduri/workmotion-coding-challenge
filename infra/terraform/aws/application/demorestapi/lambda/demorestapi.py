# coding: utf-8
import json
import re

p = re.compile("\\s*€$")

def lambda_handler(event, context):
    try:
        body = event['body']
        return {
            "statusCode": 200,
            "headers" : {"Content-Type": "application/text"},
            "body": "Welcome to our demo API, here are the details of your request:\n"
                    + "Headers: " + (str(event['headers']['Content-Type']) if 'Content-Type' in str(event['headers']) else str('No Content-Type Header Found'))
                    + "\nMethod: " + str(event['httpMethod']) + "\tBody: " + str(body)
        }
    except ValueError as e:
        return {
            "statusCode": 400,
            "headers" : {"Content-Type": "application/json"},
            "body": json.dumps({"cause":str(e)}),
            "isBase64Encoded" : "false"
        }
    except Exception as e:
        print(e.__str__())
        return {
            "statusCode": 500,
            "headers" : {"Content-Type": "application/json"},
            "body": json.dumps({"cause":"internal server error"}),
            "isBase64Encoded" : "false"
        }