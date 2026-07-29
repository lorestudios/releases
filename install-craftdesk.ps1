[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$setupUrl = if ($env:CRAFTDESK_PREVIEW_SETUP_URL) {
    $env:CRAFTDESK_PREVIEW_SETUP_URL
} else {
    "https://github.com/lorestudios/releases/releases/download/craftdesk-preview/craftdesk-setup-windows-amd64.exe"
}
$setup = Join-Path ([IO.Path]::GetTempPath()) (
    "craftdesk-preview-setup-" + [Guid]::NewGuid().ToString("N") + ".exe"
)

try {
    Invoke-WebRequest -UseBasicParsing -Uri $setupUrl -OutFile $setup `
        -MaximumRedirection 5 -TimeoutSec 120
    $length = (Get-Item -LiteralPath $setup).Length
    if ($length -le 0 -or $length -gt 67108864) {
        throw "Craftdesk setup size is outside the allowed range."
    }
    & $setup /install
    if ($LASTEXITCODE -ne 0) {
        throw "Craftdesk setup exited with code $LASTEXITCODE."
    }
} finally {
    Remove-Item -LiteralPath $setup -Force -ErrorAction SilentlyContinue
}
