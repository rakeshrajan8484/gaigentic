<#
  launch.ps1 – Windows double‑click wrapper for launch.sh
  Prerequisites: Docker Desktop with WSL 2 backend enabled
#>
if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
  Write-Error "WSL 2 is required.  Install/enable WSL and restart Docker Desktop." ; exit 1
}

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
wsl bash -c "cd '$scriptPath' && chmod +x launch.sh && ./launch.sh"
