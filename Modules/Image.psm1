# Lucas Brown #

Write-Host "This operation will create an image of the specified partition(s) and place the image(s) into a specified destination."
$start = Read-Host -Prompt "Continue? (y/N)"
If ( $start -ne "y" ) {exit}

Get-Volume | Out-Host

$sourdir = Read-Host -Prompt "What partition(s) would you like to image? [Format: X:,Y:,Z:] "
$allcrit = Read-Host -Prompt "Are operating system files located on the specified partition(s)? (y/N) "
$desttype = Read-Host -Prompt "Are the file being saved to a shared folder or local volume? [ 0 = shared folder , 1 = local volume ]"
If ( $desttype -eq "0" ) {$destdir = Read-Host -Prompt "Where would you like the image stored? [Format: \\shared_folder\pathname]"}
If ( $desttype -eq "1" ) {$destdir = Read-Host -Prompt "Where would you like the image stored? [Format: X:(\pathname)]"}

$logpath = get-date -UFormat '%a_%d_%b_%Y_%T(%Z)' | foreach {$_ -replace ":", "."}

If ( $allcrit -eq "y" ) { $osfiles = "-allCritical" }

echo "wbAdmin start backup -backupTarget:$destdir -include:$sourdir $osfiles | Out-File $destdir\WindowsImageBackup\$logpath.txt
"


# Lucas Brown #
