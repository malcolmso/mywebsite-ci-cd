# pip install boto3

# import boto3
# cloudwatch = boto3.client("cloudwatch")

# aws s3 cp articles-published.png s3://bucketname/s3cret/cloudwatch-dashboard/

aws cloudwatch get-metric-widget-image `
  --metric-widget file://canary-widget.json `
  --output-format png > uptime-chart.png

