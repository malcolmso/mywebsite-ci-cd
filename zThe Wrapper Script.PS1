$top     = Get-Content "article-wrapper-top.html"
$bottom  = Get-Content "article-wrapper-bottom.html"
$articleDir = "articles"

Get-ChildItem $articleDir -Filter *.html | ForEach-Object {
    $file = $_.FullName
    $body = Get-Content $file
    $combined = $top + @($body) + $bottom
    Set-Content $file $combined
}