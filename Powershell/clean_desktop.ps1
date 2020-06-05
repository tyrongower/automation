$DesktopPath = [Environment]::GetFolderPath("Desktop")
$CleanupPath = $DesktopPath + "\Cleanup"

Write-Host DesktopPath
New-Item $CleanupPath -ItemType Directory -Force

Get-ChildItem -Filter *.* -Path $DesktopPath -File | ForEach-Object {
    if ($_.Extension -eq ".lnk") {
        $_.Delete()
        Continue
    }

    $dest = Join-Path -Path $CleanupPath -ChildPath $_.Name

    $count = 1
    while (Test-Path -Path $dest) {
        $dest = Join-Path -Path $CleanupPath -ChildPath  ($_.BaseName + "$count" + $_.Extension) 
    }

    Move-Item -Path $_.FullName -Destination $dest

}

Get-ChildItem -Path $DesktopPath -Directory -Filter * | ForEach-Object {

    Write-Host $_.FullName
    if ($_.FullName -eq $CleanupPath) {
        Continue
    }

    $dest = Join-Path -Path $CleanupPath -ChildPath $_.Name

    $count = 1
    while (Test-Path -Path $dest) {
        $dest = Join-Path -Path $CleanupPath -ChildPath  ($_.BaseName + " $count" ) 
    }
    
    Move-Item -Path $_.FullName -Destination $dest 

}

$DesktopPath = [Environment]::GetFolderPath("CommonDesktopDirectory")

Get-ChildItem -Filter *.lnk -Path $DesktopPath | ForEach-Object {
    $_.Delete()
}

