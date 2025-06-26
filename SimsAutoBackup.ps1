$host.UI.RawUI.WindowTitle = "SIMSBACKUP_$PID"

<#
.SYNOPSIS
    Automatically backs up Sims 4 save files.
.DESCRIPTION
    Backs up Sims 4 saves every 15-30 minutes and keeps only a few backups.
#>

# Configuration
$SimsSavesPath = "$env:USERPROFILE\OneDrive\Documents\Electronic Arts\The Sims 4\saves"
$BackupFolder = "$env:USERPROFILE\OneDrive\Documents\Sims4_Backups"
$BackupIntervalMinutes = 30  # How often it backs up
$MaxBackupsToKeep = 5       # Reduced from 20 to 5 backups

# Create backup folder if it doesn't exist
if (-not (Test-Path -Path $BackupFolder)) {
    New-Item -ItemType Directory -Path $BackupFolder | Out-Null
    Write-Host "Created backup directory at $BackupFolder"
}

function CreateBackup {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupName = "Sims4_Saves_$timestamp"
    $backupPath = Join-Path -Path $BackupFolder -ChildPath $backupName
    
    try {
        # Create the backup folder first (if it doesn't exist)
        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
        
        # Copy only save files (not other files in the directory)
        $saveFiles = Get-ChildItem -Path $SimsSavesPath -Filter "*.save"
        if ($saveFiles.Count -eq 0) {
            Write-Host "No save files found to backup at $(Get-Date -Format 'HH:mm:ss')"
            return
        }
        
        $saveFiles | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination $backupPath -Force
        }
        
        Write-Host "Backup created at $(Get-Date -Format 'HH:mm:ss') in $backupPath"
        
        # Delete oldest backups if too many exist
        $backups = Get-ChildItem -Path $BackupFolder -Directory | Sort-Object CreationTime -Descending
        if ($backups.Count -gt $MaxBackupsToKeep) {
            $oldestBackups = $backups | Select-Object -Last ($backups.Count - $MaxBackupsToKeep)
            foreach ($oldBackup in $oldestBackups) {
                Remove-Item -Path $oldBackup.FullName -Recurse -Force
                Write-Host "Removed old backup: $($oldBackup.Name)"
            }
        }
    }
    catch {
        Write-Host "Error creating backup: $_" -ForegroundColor Red
    }
}

# ======================
# ENHANCED MAIN LOOP
# ======================
Write-Host "Starting Sims 4 Auto-Backup script..."
Write-Host "Backups will be created every $BackupIntervalMinutes minutes"
Write-Host "Maximum backups to keep: $MaxBackupsToKeep"
Write-Host "Press Ctrl+C to stop the script"

# Global error handling
while ($true) {
    try {
        # 1. Run backup
        CreateBackup

        # 2. Log success
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Add-Content "$env:USERPROFILE\backup_log.txt" "[$timestamp] Backup completed successfully."

        # 3. Wait for next interval (even if errors occur)
        Start-Sleep -Seconds ($BackupIntervalMinutes * 60)
    }
    catch {
        # Log critical failures
        $errorMsg = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] CRITICAL ERROR: $_"
        Write-Host $errorMsg -ForegroundColor Red
        Add-Content "$env:USERPROFILE\backup_errors.log" $errorMsg

        # Wait 5 mins before retrying (prevents rapid crashes)
        Start-Sleep -Seconds 300
    }
}
