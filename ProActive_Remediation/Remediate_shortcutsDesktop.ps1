$OneDrive = @()
$Cleandedicons = "unkown"

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

        if (($icons.Count -gt "0")) {
            #Below necessary for Intune as of 10/2019 will only remediate Exit Code 1
            
            foreach ($Item in $Icons) {
                write-host The item ($item).fullname is removed -ForegroundColor Red
                remove-item $Item.FullName -Force 
                $Cleandedicons = "Yes"
            }


        }

    }
    if ($Cleandedicons -eq "Yes") {

        Add-Type -AssemblyName System.Windows.Forms
        $global:balmsg = New-Object System.Windows.Forms.NotifyIcon
        $path = (Get-Process -id $pid).Path
        $balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
        $balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
        $balmsg.BalloonTipText = 'We removed the duplicated icons of Microsoft Teams or Edge'
        $balmsg.BalloonTipTitle = "Keep your desktop clean"
        $balmsg.Visible = $true
        $balmsg.ShowBalloonTip(40000)
    }      
}
catch {
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}