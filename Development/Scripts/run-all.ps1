<#
  Start the whole demo: backend + 3 dedicated shards (A/B/C), each in its own window.
  Run:  powershell -ExecutionPolicy Bypass -File scripts\run-all.ps1
  Stop: scripts\stop-all.ps1  (or just close the windows)
#>

$scripts = $PSScriptRoot

Write-Host "About to launch:" -ForegroundColor Yellow
Write-Host "  - backend        http://localhost:8443"
Write-Host "  - shard A        Downtown    (port 27015)"
Write-Host "  - shard B        Industrial  (port 27017)"
Write-Host "  - shard C        Jail        (port 27019)"
Write-Host "That's 4 separate windows (1 backend + 3 dedicated servers)." -ForegroundColor Yellow
$confirm = Read-Host "Start everything? (y/N)"
if ($confirm -notmatch '^(y|yes)$') {
  Write-Host "Cancelled - nothing started." -ForegroundColor Red
  exit 0
}
Write-Host ""

Write-Host "Starting backend (http://localhost:8443)..." -ForegroundColor Cyan
Start-Process cmd -ArgumentList '/k', "`"$scripts\run-backend.bat`""
Start-Sleep -Seconds 3

foreach ($s in 'A','B','C') {
  Write-Host "Starting shard $s..." -ForegroundColor Cyan
  Start-Process cmd -ArgumentList '/k', "`"$scripts\run-shard.bat`" $s"
  Start-Sleep -Seconds 2
}

Write-Host ""
Write-Host "Launched backend + shards A/B/C in separate windows." -ForegroundColor Green
Write-Host "Connect a client from the game console:  status  (on a shard) to read its lobby id,"
Write-Host "then  connect <lobbyId>  (or  connect local  with +net_allow_local)."
Write-Host "Stop everything with scripts\stop-all.ps1"
