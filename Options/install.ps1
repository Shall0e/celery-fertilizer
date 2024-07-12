$releaseTag = (Invoke-WebRequest -Uri 'https://api.github.com/repos/sten-code/Celery/releases/latest' | ConvertFrom-Json).tag_name
$releaseUrl = "https://api.github.com/repos/sten-code/Celery/releases/tags/$releaseTag"
$localAppData = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::localApplicationData)

$wc = New-Object net.webclient
$wc.Downloadfile($video_url, $local_video_url)
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

Clear-Host
Write-Host "Installing Latest Release, v$releaseTag..."

try {
    $response = Invoke-RestMethod -Uri $releaseUrl
    $assetUrl = ($response.assets | Where-Object { $_.name -like "*.zip" }).browser_download_url

    if ($assetUrl) {
        $outputFile = (Join-Path (Get-Item -Path ".\").Parent.FullName "release.zip")
        $ProgressPreference = 'Continue'
        $wc.Downloadfile($assetUrl, $outputFile)
        Write-Host -ForegroundColor Green "Release zip file downloaded successfully."
        Expand-Archive -Path $outputFile -DestinationPath (Join-Path $localAppData "Celery") -Force
        Write-Host -ForegroundColor Green "Items extracted to %localappdata%/Celery"
        Remove-Item -Path $outputFile
        Write-Host -ForegroundColor Green "Deleted .zip file."
    }
} catch {
    Write-Host -ForegroundColor Red "Error fetching or downloading the release zip file."
}

Write-Host "Windows Defender needs Admin to add exclusion paths."
Add-MpPreference -ExclusionPath (Join-Path $localAppData "Celery")
Add-MpPreference -ExclusionPath (Join-Path $roamingAppData "Celery")
Start-Sleep -Seconds 2
Write-Host -ForegroundColor Green "Added Windows Defender exclusions, no more missing DLLs!"

Write-Host "Finished!"

Write-Host ' '
Write-Host -ForegroundColor Magenta "(Press any key to go back)" -NoNewline
$null = Read-Host
