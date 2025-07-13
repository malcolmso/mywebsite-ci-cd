import boto3

# Create CloudWatch client
cloudwatch = boto3.client("cloudwatch")

# Push a custom metric
response = cloudwatch.put_metric_data(
    Namespace="S3cretLab",
    MetricData=[
        {
            "MetricName": "ArticlesPublished",
            "Value": 1,
            "Unit": "Count",
            "Dimensions": [
                {
                    "Name": "Source",
                    "Value": "BlogGenerator"
                }
            ]
        }
    ]
)

print("✅ Metric pushed to CloudWatch under namespace 'S3cretLab'")
