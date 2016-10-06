function Backup($Dest, $Dirs) {
	#Variables
	$bDirs="C:\Users"
	$Log="Log.txt"


	#Hard Variables - Do not change
	$BackupDir=$Dest +"\Backup-"+ (Get-Date).ToString('y/M/d')+"-"+(Get-Random -Maximum 1000)+"\"


	#Functions
	#Logger
	Function Log ($Type, $Message) {
		$LD=(Get-Date).ToString('d.M.y-H:m:s')

		if (!(Test-Path -Path $Log)) {
			New-Item -Path $Log -ItemType File | Out-Null
		}
		$Text="$LD - $Type"+":"+" $Message"

		add-Content -Path $Log -Value $Text

	}

	Log "INFO" "~~~-------------------------------------------------------~~~"
	Log "INFO" "Initializing Backup"

	#bDir Manager
	Function Make-bDir {
	Log "INFO" "Creating Backup Directory: $BackupDir"
	New-Item -Path $BackupDir -ItemType Directory | Out-Null

	Log "INFO" "Migrating Log to $BackupDir"
	Move-Item -Path $Log -Destination $BackupDir

	Set-Location $Backupdir
	Log "INFO" "Selecting Backup Directory : $BackupDir"
	}

	#Verify Directories
	function Ver-Dir {
		Log "INFO" "Verifying content specified exists"
		if (!(Test-Path $Dirs)) {
			return $false
			Log "Error" "$BackupDirs does not exist"
		}
		if (!(Test-Path $Destination)) {
			return $false
			Log "Error" "$Dest does not exist"
		}
		if (!(Test-Path $BackupDir)) {
			return $false
			Log "Error" "$BackupDir does not exist"
		}
	}


	#Actual Backup Function
	function Mk-Backup {
		Log "INFO" "Started Backup"
		

		foreach ($Backup in $Dirs) {
			Log "INFO" "Backing up $Backup"
			robocopy $Backup $Dest /e /b /sec
		}
	}



	#Running Code

	if (!($Dirs)) {
	$Dirs=$bDirs
	}
	if (!($Dest)) {
		Write-Host "The Syntax is: Backup Destination {'Directory to backup 1', 'Dir2'}"
		return $false
	}
	Make-bDir


	#Check Dirs
	$VerStat=Ver-Dir
	if ($VerStat -eq $false) {
		Log "ERROR" "One or more Directories is not valid. Execution cancelled. The terrorists win."
	} else {
		Log "INFO" "No errors detected in setup."

		Mk-Backup

		Log "INFO" "Backup should be completed"
	}
}
