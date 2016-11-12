Write-Host "This operation will create an image of the specified partition(s) and place the image(s) into a specified destination."
$start = Read-Host -Prompt "Continue? (y/N)"
If ( $start -ne "y" ) {exit}


$sourdir = Read-Host -Prompt "What partition(s) would you like to image? [Format: X:,Y:,Z:] "
$allcrit = Read-Host -Prompt "Are operating system files located on the specified partition(s)? (y/N) "
$destdir = Read-Host -Prompt "Where would you like the image stored? [Format: X:]"


