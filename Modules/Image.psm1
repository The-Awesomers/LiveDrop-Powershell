# Lucas Brown #

Write-Output "This operation will create an image of the specified partition(s) and place the image(s) into a specified destination."
$start = Read-Host -Prompt "Continue? (y/N)"
If ( $start -ine "y" ) {exit}

#$logtime = get-date -UFormat "%Y-%m-%d %H%M%S" <# This is the default wbadmin date format. Can be swapped for line below if desired. Sets logfile format. #>
$logtime = get-date -UFormat '%a_%d_%b_%Y_%T(UTC%Z)' | foreach {$_ -replace ":", "."}
$temp = "$env:USERPROFILE\AppData\Local\Temp\temptranscript.txt"   # Creates temporary logfile.
Write-Output "This a log of the actions attempted at $logtime." > $temp 

Do { Get-Volume | Tee-Object -Append $temp | Out-Host   # Obtain list of connected Drives/Volumes
    <# Start to setup variables for final command. #>
    Write-Output "`n This process will only work with drives identified as 'Fixed' in the above table. `n Some USB flash drives will be labelled as this, but not all. `n" | Tee-Object -Append $temp 
    Write-Output "What partition(s) would you like to capture/take an image of? [Format: X:,Y:,Z:] " | Tee-Object -Append $temp 
       $sourdir = Read-Host | Tee-Object -Append $temp 
    Write-Output "Are operating system files located on the specified partition(s)? (y/N) " | Tee-Object -Append $temp 
       $allcrit = Read-Host | Tee-Object -Append $temp ; If ( $allcrit -ieq "y" ) {$osfiles = "-allCritical"}
    Write-Output "Are the file being saved to a shared/network folder or local volume? [ 0 = shared folder , 1 = local volume ] " | Tee-Object -Append $temp 
       [int]$desttype = Read-Host | Tee-Object -Append $temp 
     If ( $desttype -eq 0 ) {
      Write-Output "Where would you like the image stored? [Format: \\network_share\shared_folder(\pathname)] " | Tee-Object -Append $temp 
        $destdir = Read-Host | Tee-Object -Append $temp 
      Write-Output "Specify a user with access to the specified shared folder : " | Tee-Object -Append $temp 
        $validusr = Read-Host | Tee-Object -Append $temp 
      Write-Output "Does this account have a password? (y/N)" | Tee-Object -Append $temp 
        $needpass = Read-Host | Tee-Object -Append $temp 
         If ( $needpass -ieq "y" ) { Write-Output "Specify the user's password : " | Tee-Object -Append $temp 
           $validpas = Read-Host -AsSecureString | Tee-Object -Append $temp  }}
     ElseIf ( $desttype -eq 1 ) { Write-Output "Where would you like the image stored? [Format: X:(\pathname)] " | Tee-Object -Append $temp 
        $destdir = Read-Host | Tee-Object -Append $temp }
     <# Issue a verification before process execution. #>
     do {Write-Output "You are about to backup the $sourdir drive to the following destination: $destdir. Are you sure you want to continue? (y/N) " | Tee-Object -Append $temp 
       $verify = Read-Host | Tee-Object -Append $temp } While (!$verify)
     If ($verify -ieq "n") { Write-Output "Would you like to restart? (y/N) " | Tee-Object -Append $temp 
       $restart = Read-Host | Tee-Object -Append $temp } 
     If ($restart -ieq "n") {Write-Output "You have decided to cancel your backup process. Now exiting." ; Remove-Item $temp ; exit }
    } While ($restart -ieq "y")

$log = "$destdir\WindowsImageBackup\Image_Log_$logtime.txt"
If (!"$destdir\WindowsImageBackup\$env:COMPUTERNAME") {mkdir "$destdir\WindowsImageBackup\$env:COMPUTERNAME\" -ErrorAction SilentlyContinue}
Move-Item $temp $log -ErrorAction SilentlyContinue   # Move the file to final location

function Done { <# Used to notify when process is completed. #>
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("Volume Successfully Imaged",0,"Image",0x1)}

If ( $desttype -eq 0 ) { $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($validpas)
     $unspass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR) 
<# ^^ Found this particular part online. It converts the password from a secure string to plaintext, temporarily. Could be exploited; use with caution. ^^ #>;
     Write-Output " This process will take some time. A popup will appear when it completes " | Tee-Object -Append $log
     wbadmin start backup -backupTarget:"$destdir\WindowsImageBackup\$env:COMPUTERNAME\" -include:$sourdir -user:$validusr -password:$unspass $osfiles  | Tee-Object -Append $log 
     Write-Output "A log file can be located at the following location $log." ; Done}
ElseIf ( $desttype -eq 1 ) { wbAdmin start backup -backupTarget:$destdir -include:$sourdir $osfiles | Tee-Object -Append $log 
    Write-Output "A log file can be located at the following location $log." ; Done }
Else {Write-Output "Process cannot be executed. Please review previous parameters." | Tee-Object -Append $log }

# Lucas Brown #
