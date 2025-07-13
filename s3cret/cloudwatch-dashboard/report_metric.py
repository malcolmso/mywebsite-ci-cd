import boto3
from datetime import datetime, timedelta, timezone

# Initialize CloudWatch client
cloudwatch = boto3.client("cloudwatch")

# Define your metric setup
namespace = "S3cretLab"
metric_name = "ArticlesPublished"
dimension = { "Name": "Source", "Value": "BlogGenerator" }

# Simulate 10 publishing events spaced 5 minutes apart
print("📡 Starting CloudWatch metric push...\n")

for i in range(10):
    # Generate timestamp in the last hour (every 5 minutes)
    timestamp = datetime.now(timezone.utc) - timedelta(minutes=5 * i)

    cloudwatch.put_metric_data(
        Namespace=namespace,
        MetricData=[
            {
                "MetricName": metric_name,
                "Value": 1,
                "Unit": "Count",
                "Timestamp": timestamp,
                "Dimensions": [dimension]
            }
        ]
    )

    print(f"✅ Article {i+1} pushed at {timestamp.isoformat()}")

print("\n✅ All metrics pushed to CloudWatch under namespace 'S3cretLab'")
