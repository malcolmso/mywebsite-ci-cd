$top     = Get-Content "article-wrapper-top.html"
$bottom  = Get-Content "article-wrapper-bottom.html"

Get-ChildItem "articles" -Filter *.html | ForEach-Object {
    $file = $_.FullName
    $body = Get-Content $file
    Set-Content $file ($top + $body + $bottom)
    Write-Host "📦 Rewrapped:" $_.Name
}