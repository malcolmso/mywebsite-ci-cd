$top     = Get-Content "article-wrapper-top.html"
$bottom  = Get-Content "article-wrapper-bottom.html"
$articleDir = "articles"

Get-ChildItem $articleDir -Filter *.html | ForEach-Object {
    $file = $_.FullName
    $body = Get-Content $file -Raw

    if ($body -match "<nav>") {
        Write-Host "⏭️ Skipped (already wrapped):" $_.Name
    } else {
        $wrapped = $top + $body.Split("`n") + $bottom
        Set-Content $file $wrapped
        Write-Host "📦 Rewrapped:" $_.Name
    }
}