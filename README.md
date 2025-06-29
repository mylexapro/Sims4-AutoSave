# Sims 4 AutoSave to GitHub

A PowerShell script that automatically backs up your Sims 4 saves to GitHub with configurable intervals and retention policies.

![PowerShell](https://img.shields.io/badge/PowerShell-%235391FE.svg?style=for-the-badge&logo=powershell&logoColor=white)
![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)

## Recent Improvements

### v1.1.0 - Optimization Update
- 🔍 **Selective Backup**: Now only copies `.save` files instead of entire directory
- 🗑️ **Smarter Cleanup**: Fixed backup deletion to properly maintain only 5 most recent backups
- ✅ **Save File Verification**: Added check for existence of save files before backup
- ⏱️ **Reduced Storage Usage**: Decreased maximum backups from 20 to 5
- 📝 **Enhanced Logging**: Improved error handling and status messages

```diff
- Old: Backed up entire saves directory, kept 20 copies
+ New: Only backs up .save files, maintains 5 copies, verifies files exist
```

## ✨ Features
- ⏰ Automatic saves every 30 minutes (configurable)
- 🗃️ Keeps last 20 save versions (configurable)
- 📂 Auto-creates necessary folders
- ☁️ GitHub backup for cloud storage
- 🔄 Automatic cleanup of old saves

## 🛠️ Prerequisites
- Windows PC with PowerShell 5.1+
- Git installed and configured
- GitHub account with a repository
- Sims 4 installed (default location or modify script)

## 🚀 Installation
1. Clone this repository or download the script
2. Edit these variables in the script:
   ```powershell
   $GitHubRepoPath = "C:\path\to\your\github\repo"  # Your local GitHub repo
   $BackupInterval = 30                            # Minutes between saves
   $MaxBackups = 20                                # Maximum save files to keep

## To Run the script in PowerShell:
.\Sims4AutoSaveToGitHub.ps1

The script will:

Create backup folders if missing
Start automatic save backups
Delete oldest saves when exceeding $MaxBackups
Push changes to GitHub

⚙️ Automated Setup (Recommended)
Create a scheduled task to run when:

You log in to Windows, OR
When Sims4.exe launches
Example Task Scheduler setup:
Trigger: At log on
Action: Start a program
Program: powershell.exe
Arguments: -ExecutionPolicy Bypass -File "C:\path\to\Sims4AutoSaveToGitHub.ps1"

❓ FAQ
Q: Where does the script find my Sims 4 saves?
A: By default it checks the standard location:
Documents\Electronic Arts\The Sims 4\saves\

Q: How do I change the backup frequency?
A: Modify the $BackupInterval variable in the script.

Q: My GitHub pushes fail - help!
A: Ensure you have:

Proper Git authentication setup (SSH or PAT)
Network connectivity
Repository exists and is accessible

## ⚖️ Usage  
Feel free to use, modify, and share this script - no permission needed!

