$roamingAppData = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::ApplicationData)
$localAppData = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::localApplicationData)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ErrorActionPreference= 'silentlycontinue'
$ProgressPreference = 'silentlycontinue'

function betterPause {
    param (
        [string]$Message
    )

    if ($Message) {
        Write-Host -ForegroundColor Red $Message
    }
    Write-Host ' '
    Write-Host -ForegroundColor Magenta "(Press any key to go back)" -NoNewline
    $null = Read-Host
}

function Remove-FolderWithRetry {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FolderPath,
        
        [int]$MaxAttempts = 3
    )
    $attempts = 0
    $deleted = $false
    while (-not $deleted -and $attempts -lt $MaxAttempts) {
        try {
            Remove-Item -Path $FolderPath -Recurse -Force -ErrorAction Stop
            $deleted = $true
            Write-Host -ForegroundColor Green "Folder '$FolderPath' deleted successfully."
        }
        catch {
            $attempts++
            Start-Sleep -Seconds 1
        }
    }
    if (-not $deleted) {
        Write-Host -ForegroundColor Red "Failed to delete folder '$FolderPath' after $MaxAttempts attempts."
    }
}

Clear-Host
Write-Host "Uninstalling Celery..."

Stop-Process -Name "CefSharp.BrowserSubprocess" -Force
Stop-Process -Name "CeleryInject" -Force
Write-Host -ForegroundColor Green "Killed injector"

Stop-Process -Name "Celery" -Force
Stop-Process -Name "CeleryApp" -Force
Stop-Process -Name "Main" -Force
Write-Host -ForegroundColor Green "Killed window"

Stop-Process -Name "Node.js JavaScript Runtime" -Force
Write-Host -ForegroundColor Green "Killed server"

Remove-FolderWithRetry -FolderPath (Join-Path $roamingAppData "Celery") -MaxAttempts 5
Remove-FolderWithRetry -FolderPath (Join-Path $localAppData "Celery") -MaxAttempts 5

Write-Host "Windows Defender needs Admin to remove exclusion paths."
Remove-MpPreference -ExclusionPath (Join-Path $localAppData "Celery")
Remove-MpPreference -ExclusionPath (Join-Path $roamingAppData "Celery")
Start-Sleep -Seconds 2
Write-Host -ForegroundColor Green "Removed Windows Defender exclusions"

Write-Host "Done! Sorry to see you go."

betterPause