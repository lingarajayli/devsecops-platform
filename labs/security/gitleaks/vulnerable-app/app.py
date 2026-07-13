import os

def connect_to_service():
    aws_access_key_id = os.getenv("AWS_ACCESS_KEY_ID")
    aws_secret_access_key = os.getenv("AWS_SECRET_ACCESS_KEY")
    github_token = os.getenv("GITHUB_TOKEN")

    if not github_token:
        print("GitHub token is not configured.")
        return

    print("Connecting to service securely using environment variables...")

if __name__ == "__main__":
    connect_to_service()
