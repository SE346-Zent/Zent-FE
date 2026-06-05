$presentationPath = 'lib\presentation'
$importLine = "import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';"

$files = Get-ChildItem -Path $presentationPath -Filter '*.dart' -Recurse |
    Where-Object { (Get-Content $_.FullName -Raw) -match '(?<!Throttled)GestureDetector\(' }

foreach ($file in $files) {
    # Skip tap_debounce.dart itself
    if ($file.FullName -like '*tap_debounce*') { continue }

    $content = Get-Content $file.FullName -Raw -Encoding UTF8

    # Only process files that still have un-throttled GestureDetector
    if ($content -notmatch '(?<!Throttled)GestureDetector\(') { continue }

    # Replace bare GestureDetector( with ThrottledGestureDetector(
    $content = $content -replace '(?<!Throttled)GestureDetector\(', 'ThrottledGestureDetector('

    # Add import if not already present
    if ($content -notmatch 'tap_debounce') {
        $flutterImport = "import 'package:flutter/material.dart';"
        $content = $content.Replace($flutterImport, $flutterImport + "`r`n" + $importLine)
    }

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
    Write-Host "Patched: $($file.Name)"
}

Write-Host "Done."
