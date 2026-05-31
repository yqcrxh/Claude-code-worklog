# SessionStart hook (Windows / PowerShell).
# Create the two log files if missing; start empty, grow by appending.
# NOTE: keep this file ASCII-only (incl. comments). Windows PowerShell 5.1 reads
# a BOM-less .ps1 as GBK/ANSI; non-ASCII bytes can corrupt the script.
$enc = New-Object System.Text.UTF8Encoding $false
foreach ($f in @('WORKLOG.md', 'WORKLOG_index.md')) {
    if (-not (Test-Path $f)) {
        [System.IO.File]::WriteAllText((Join-Path (Get-Location) $f), '', $enc)
    }
}
