import json


def handler(event, context):
    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "message": "Hello from Floci Lambda",
                "service": "flask-health-api",
                "environment": "dev",
            }
        ),
    }