$articleDir = "articles"

Get-ChildItem $articleDir -Filter *.html | ForEach-Object {
    $file = $_.FullName
    $html = Get-Content $file -Raw

    $mainStart = $html.IndexOf("<main>")
    $mainEnd   = $html.LastIndexOf("</main>")

    if ($mainStart -ge 0 -and $mainEnd -ge $mainStart) {
        $innerHtml = $html.Substring($mainStart + "<main>".Length, $mainEnd - ($mainStart + "<main>".Length)).Trim()

        # Remove embedded nav, html, head, script, body tags
        $cleaned = [System.Text.RegularExpressions.Regex]::Replace(
            $innerHtml,
            "(?s)<(html|head|script|body|nav).*?</\1>",
            "",
            "IgnoreCase"
        ).Trim()

        Set-Content $file $cleaned
        Write-Host "✅ Deep cleaned:" $_.Name
    } else {
        Write-Host "⚠️ Skipped (no <main>):" $_.Name
    }
}