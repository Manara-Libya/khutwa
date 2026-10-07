# Khutwa prompt tuner installer (Windows).  Usage:  irm {BASE_URL}/install.ps1 | iex
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
$Base = "{BASE_URL}"
$Dir = Join-Path $HOME ".khutwa"
$Bin = Join-Path $HOME ".local\bin"
New-Item -ItemType Directory -Force -Path $Dir, $Bin | Out-Null

Write-Host ""
Write-Host "  Installing the Khutwa prompt tuner" -ForegroundColor Cyan
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "  - installing uv (Python runner)..."
    powershell -ExecutionPolicy ByPass -NoProfile -Command "irm https://astral.sh/uv/install.ps1 | iex" | Out-Null
    $env:Path = "$Bin;$env:Path"
}
Write-Host "  - downloading the tuner..."
$Script = Join-Path $Dir "khutwa-tune.py"
Invoke-WebRequest "$Base/tools/khutwa-tune.py" -OutFile $Script -UseBasicParsing

Set-Content -Path (Join-Path $Bin "khutwa-tune.cmd") -Encoding ASCII `
    -Value "@echo off`r`nuv run --quiet --script `"%USERPROFILE%\.khutwa\khutwa-tune.py`" %*"
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (-not ($UserPath -split ";" | Where-Object { $_ -eq $Bin })) {
    [Environment]::SetEnvironmentVariable("Path", "$Bin;$UserPath", "User")
}
$env:Path = "$Bin;$env:Path"

Write-Host "  - preparing dependencies (first time only)..."
uv run --quiet --script $Script --set-url $Base --set-discovery "{DISCOVERY_URL}"
uv run --quiet --script $Script --check | Out-Null

Write-Host ""
Write-Host "  Done! Run:  khutwa-tune" -ForegroundColor Green
Write-Host "  (In a new terminal if the command isn't found.) Paste your API key and developer key on first launch."
Write-Host ""
