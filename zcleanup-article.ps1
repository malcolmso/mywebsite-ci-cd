$articleDir = "articles"

Get-ChildItem $articleDir -Filter *.html | ForEach-Object {
    $file   = $_.FullName
    $html   = Get-Content $file -Raw

    $mainStart = $html.IndexOf("<main>")
    $mainEnd   = $html.IndexOf("</main>")

    if ($mainStart -ge 0 -and $mainEnd -ge $mainStart) {
        $contentOnly = $html.Substring($mainStart + 6, $mainEnd - $mainStart - 6).Trim()
        Set-Content $file $contentOnly
        Write-Host "✅ Cleaned:" $_.Name
    } else {
        Write-Host "⚠️ Skipped (no <main>):" $_.Name
    }
}