$xAppName    = "LiveDrop Menu"
[BOOLEAN]$global:xExitSession=$false
function LoadMenuSystem(){
	[INT]$xMenu1=0
	[INT]$xMenu2=0
	[BOOLEAN]$xValidSelection=$false
	while ( $xMenu1 -lt 1 -or $xMenu1 -gt 4 ){
		CLS
		#… Present the Menu Options
		Write-Host "`n`tMulti Layered Menu Demonstration - Live-Drop menu`n" -ForegroundColor Magenta
		Write-Host "`t`tPlease select the admin area you require`n" -Fore Cyan
		Write-Host "`t`t`t1. Backup" -Fore Cyan
		Write-Host "`t`t`t2. Update" -Fore Cyan
		Write-Host "`t`t`t3. Image" -Fore Cyan
		Write-Host "`t`t`t4. Quit and exit`n" -Fore Cyan
		#… Retrieve the response from the user
		[int]$xMenu1 = Read-Host "`t`tEnter Menu Option Number"
		if( $xMenu1 -lt 1 -or $xMenu1 -gt 4 ){
			Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
		}
	}
	Switch ($xMenu1){    #… User has selected a valid entry.. load next menu
            1 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 4 ){
				CLS
				# Present the Menu Options
				Write-Host "`n`tLive-Drop Menu`n" -Fore Magenta
				Write-Host "`t`tPlease Select Task`n" -Fore Cyan
				Write-Host "`t`t`t1. Run Backup Script" -Fore Cyan
				Write-Host "`t`t`t2. Quit`n" -Fore Cyan
				
                [int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
				if( $xMenu2 -lt 1 -or $xMenu2 -gt 4 ){
					Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
				}
			}
			Switch ($xMenu2){
				
                1{ Write-Host "`n`tYou Selected Option 1 – Import-module`n"{Import-module .\Modules\Backup.psm1} -Fore Yellow;start-Sleep -Seconds 3; Backup C:\BackupFolder C:\Intel }
                
				Default { Write-Host "`n`tYou Selected Option 2 – Quit the Administration Tasks`n" -Fore Yellow; break}
				
			}
		}
		2 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 4 ){
				CLS
				# Present the Menu Options
				Write-Host "`n`tLive-Drop Menu`n" -Fore Magenta
				Write-Host "`t`tPlease Select Task`n" -Fore Cyan
				Write-Host "`t`t`t1. Run update Script" -Fore Cyan
				Write-Host "`t`t`t2. Quit`n" -Fore Cyan
				[int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
			}
			if( $xMenu2 -lt 1 -or $xMenu2 -gt 4 ){
				Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
			}
			Switch ($xMenu2){
				1{ Write-Host "`n`tYou Selected Option 1 – Import Module`n" {Import-Module .\Modules\Update.psm1} -Fore Yellow;start-Sleep -Seconds 3; Update }
                
				default { Write-Host "`n`tYou Selected Option 2 – Quit`n" -Fore Yellow; break}
			}
		}
		3 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 4 ){
				CLS
		        Write-Host "`n`tLive-Drop Menu `n" -Fore Magenta
				Write-Host "`t`tPlease Select Task`n" -Fore Cyan
				Write-Host "`t`t`t1. Run Image Script" -Fore Cyan
				Write-Host "`t`t`t2. Quit`n" -Fore Cyan
				[int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
				if( $xMenu2 -lt 1 -or $xMenu2 -gt 4 ){
					Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
				}
			}
			Switch ($xMenu2){
				1{ Write-Host "`n`tYou Selected Option 1  `n" -Fore Yellow;start-Sleep -Seconds 3 ;  .\Modules\Image.ps1}
				default { Write-Host "`n`tYou Selected Option 2 – Quit`n" -Fore Yellow; break} 
			}
		}
		default { $global:xExitSession=$true;break }
	}
}
LoadMenuSystem
If ($xExitSession){
	exit-pssession    #… User quit & Exit
}else{
	    #… Loop the function
}
