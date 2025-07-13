# Set working directory
$basePath = "C:\AWS-malcolm\mywebsite-ci-cd\s3cret\cloudwatch-dashboard"
Set-Location $basePath

# 1️⃣ Run Python metric update
Write-Host "📤 Pushing metric to CloudWatch..."
python report_metric.py

# 2️⃣ Regenerate widget image
Write-Host "🖼️ Generating PNG chart..."
aws cloudwatch get-metric-widget-image `
  --metric-widget file://widget.json `
  --output-format png > articles-published.png

# ✅ Removed: Copy-Item line to avoid self-overwrite
# If needed, you can copy to a different path like:
# Copy-Item "articles-published.png" -Destination "C:\your-deploy-folder\articles-published.png" -Force

Write-Host "✅ Dashboard chart updated."
