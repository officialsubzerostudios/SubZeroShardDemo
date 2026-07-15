<#
  Optional. The s&box dedicated server no longer ships Steam client binaries; it needs them
  linked before it can initialise Steamworks (create a lobby). If you have the Steam desktop
  client installed, this is already satisfied and you do not need this script.

  Otherwise, point the registry at your SteamCMD client DLLs (per the official doc):
  Run:  powershell -ExecutionPolicy Bypass -File scripts\setup-steamclient.ps1 -SteamCmdDir C:\steamcmd
#>
param([string]$SteamCmdDir = "C:\steamcmd")

$dll64 = Join-Path $SteamCmdDir "steamclient64.dll"
$dll   = Join-Path $SteamCmdDir "steamclient.dll"

if (-not (Test-Path $dll64)) { Write-Warning "steamclient64.dll not found at $dll64, check -SteamCmdDir." }

New-Item -Path "HKCU:\SOFTWARE\Valve\Steam\ActiveProcess" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\SOFTWARE\Valve\Steam\ActiveProcess" -Name "SteamClientDll64" -Value $dll64 -Type String
Set-ItemProperty -Path "HKCU:\SOFTWARE\Valve\Steam\ActiveProcess" -Name "SteamClientDll"   -Value $dll   -Type String

Write-Host "Set SteamClient DLL registry entries to '$SteamCmdDir'." -ForegroundColor Green
Write-Host "(Only needed if you don't have the Steam desktop client.)"
