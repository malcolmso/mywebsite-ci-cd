$articleDir = "articles"

Get-ChildItem $articleDir -Filter *.html | ForEach-Object {
    $file = $_.FullName
    $html = Get-Content $file -Raw

    $mainStart = $html.IndexOf("<main>")
    $mainEnd   = $html.LastIndexOf("</main>")

    if ($mainStart -ge 0 -and $mainEnd -ge $mainStart) {
        $bodyContent = $html.Substring($mainStart + "<main>".Length, $mainEnd - ($mainStart + "<main>".Length)).Trim()
        Set-Content $file $bodyContent
        Write-Host "✅ Re-cleaned:" $_.Name
    } else {
        Write-Host "⚠️ Still skipped (no <main>):" $_.Name
    }
}