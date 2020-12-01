$OneDrive = @()

# Define Variables
$Lang = (Get-WinSystemLocale).LCID

if ($Lang -ne "1034") {
    #United States (EN-US)
    $PP = "$env:SystemDrive\Users\"
    $PPU = (get-childitem -path $PP | Where-Object { ($_.Name -notlike "default*") } | Where-Object { ($_.Name -ne "public") }).FullName
    foreach ($OneDrive in $PPU) {
        #Find $OneDrive
        $OneDriveLocations = (get-childitem -path $PPU -Filter "OneDrive*" -ErrorAction SilentlyContinue).FullName
    }
}
elseif ($Lang -eq "1034") {
    #Dutch (NL-NL)
    $PP = "$env:SystemDrive\Gebruikers\"
    $PPU = (get-childitem -path $PP | Where-Object { ($_.Name -notlike "default*") } | Where-Object { ($_.Name -ne "publiek") }).FullName
    foreach ($OneDrive in $PPU) {
        #Find $OneDrive
        $OneDriveLocations = (get-childitem -path $PPU -Filter "OneDrive*" -ErrorAction SilentlyContinue).FullName
    }
    
}
try {
    foreach ($OneDriveLocation in $OneDriveLocations) {
        $Icons = @()
        $AllEdgeIcons = New-Object PSobject
        $AllTeamsIcons = New-Object PSobject
        $EdgeIcons = (get-childitem -Path $OneDriveLocation  -Filter "Microsoft Edge*.lnk" -Recurse -ErrorAction SilentlyContinue)
        $TeamsIcons = (get-childitem -Path $OneDriveLocation -Filter "Microsoft Teams*.lnk" -Recurse -ErrorAction SilentlyContinue)
 
        $AllEdgeIcons | Add-Member -MemberType NoteProperty -Name "Fullname" -Value $EdgeIcons.fullname
        $AllTeamsIcons | Add-Member -MemberType NoteProperty -Name "Fullname" -Value $TeamsIcons.fullname

        $icons += $EdgeIcons
        $icons += $TeamsIcons
    }
    

    if (($icons.count -gt "0")) {
        #Start remediation
        write-host "Start remediation"
        exit 1
    }
    else {
        #No remediation required    
        write-host "No remediation"
        exit 0
    }   
}
catch {
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}