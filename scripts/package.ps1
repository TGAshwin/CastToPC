param(
    [string]$Version = "1.0.0"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$buildDir = Join-Path $root "build\Release"
$packageDir = Join-Path $root "out\package"
$installerDir = Join-Path $root "out\installer"
$isccCandidates = @(
    "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
    "$env:ProgramFiles\Inno Setup 6\ISCC.exe",
    "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe"
)
$iscc = $isccCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $iscc) {
    $iscc = (Get-Command ISCC.exe -ErrorAction SilentlyContinue).Source
}
if (-not $iscc) {
    throw "Inno Setup 6 was not found. Install it from https://jrsoftware.org/isdl.php and rerun this script."
}
if (-not (Test-Path (Join-Path $buildDir "CastToPC.exe"))) {
    throw "CastToPC.exe is missing. Run scripts\build.ps1 first."
}

$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (-not (Test-Path $vswhere)) {
    throw "Visual Studio C++ Redistributable files were not found. Install the Visual Studio 2022 C++ workload."
}
$vs = & $vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
if (-not $vs) {
    throw "Visual Studio C++ tools were not found. Install the Visual Studio 2022 C++ workload."
}
$crtRoot = Join-Path $vs "VC\Redist\MSVC"
$crt = Get-ChildItem $crtRoot -Directory -ErrorAction SilentlyContinue |
    Sort-Object { try { [version]$_.Name } catch { [version]"0.0" } } -Descending |
    ForEach-Object { Join-Path $_.FullName "x64\Microsoft.VC143.CRT" } |
    Where-Object { Test-Path (Join-Path $_ "vcruntime140.dll") } |
    Select-Object -First 1
if (-not $crt) {
    throw "The x64 Visual C++ runtime files are missing. In Visual Studio Installer, add the C++ Redistributable component."
}

Remove-Item $packageDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item $packageDir -ItemType Directory -Force | Out-Null
Copy-Item (Join-Path $buildDir "CastToPC.exe") $packageDir

# Ship the application dependencies beside the app so users do not need to install them separately.
$dlls = @(
    Get-ChildItem $buildDir -File -Filter "av*.dll"
    Get-ChildItem $buildDir -File -Filter "sw*.dll"
    Get-ChildItem $buildDir -File -Filter "libcrypto-*-x64.dll"
)
if (-not ($dlls | Where-Object Name -Like "avcodec-*.dll")) { throw "The FFmpeg codec DLL is missing from build\Release." }
if (-not ($dlls | Where-Object Name -Like "libcrypto-*-x64.dll")) { throw "The OpenSSL crypto DLL is missing from build\Release." }
$dlls | Copy-Item -Destination $packageDir

Get-ChildItem $crt -File -Filter "*.dll" | Copy-Item -Destination $packageDir
Get-ChildItem $buildDir -File -Filter "legacy.dll" -ErrorAction SilentlyContinue | Copy-Item -Destination $packageDir
Copy-Item (Join-Path $root "LICENSE") $packageDir
Copy-Item (Join-Path $root "NOTICE") $packageDir
New-Item $installerDir -ItemType Directory -Force | Out-Null

& $iscc "/DMyAppVersion=$Version" (Join-Path $PSScriptRoot "casttopc.iss")
if ($LASTEXITCODE -ne 0) { throw "Inno Setup failed with exit code $LASTEXITCODE." }
Write-Host "Installer created: $(Join-Path $root "out\installer\CastToPC-Setup-$Version.exe")"
