# Lucas Brown #

Write-Host "This operation will create an image of the specified partition(s) and place the image(s) into a specified destination."
$start = Read-Host -Prompt "Continue? (y/N)"
If ( $start -ine "y" ) {exit}

Get-Volume | Out-Host
echo "`n This process will only work with drives identified as 'Fixed' in the above table. `n Some USB flash drives will be labelled as this, but not all. `n"
$sourdir = Read-Host -Prompt "What partition(s) would you like to capture/take an image of? [Format: X:,Y:,Z:] "
$allcrit = Read-Host -Prompt "Are operating system files located on the specified partition(s)? (y/N) "
If ( $allcrit -ieq "y" ) {$osfiles = "-allCritical"}
[int]$desttype = Read-Host -Prompt "Are the file being saved to a shared folder or local volume? [ 0 = shared folder , 1 = local volume ] "
If ( $desttype -eq 0 ) {
    $destdir = Read-Host -Prompt "Where would you like the image stored? [Format: \\network_share\shared_folder(\pathname)] "
    $validusr = Read-Host -Prompt "Specify a user with access to the specified shared folder "
    $needpass = Read-Host -Prompt "Does this account have a password? (y/N)"
    If ( $needpass -ieq "y" ) { $validpas = Read-Host -Prompt "Specify the user's password " -AsSecureString 
    $varpass = '-password:$validpas' } }
ElseIf ( $desttype -eq 1 ) {$destdir = Read-Host -Prompt "Where would you like the image stored? [Format: X:(\pathname)] "}


$logtime = get-date -UFormat '%a_%d_%b_%Y_%T(UTC%Z)' | foreach {$_ -replace ":", "."}
$logname = "$destdir\WindowsImageBackup\Image_$logtime.txt"
mkdir "$destdir\WindowsImageBackup\$env:COMPUTERNAME\" -ErrorAction SilentlyContinue

If ( $desttype -eq 0 ) { echo wbadmin start backup -backupTarget:$destdir -include:$sourdir -user:$validusr $varpass $osfiles  <# | Out-File -Append $logname #> }
ElseIf ( $desttype -eq 1 ) { wbAdmin start backup -backupTarget:$destdir -include:$sourdir $osfiles | Out-File -Append $logname}
Else {echo "Process cannot be executed. Please review previous parameters." $logname}


# Lucas Brown #
