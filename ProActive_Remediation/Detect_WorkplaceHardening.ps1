#Validate security recommendations MDATP

try
{
    #LLSA protection
    $REG_CREDG = "HKLM:SYSTEM\CurrentControlSet\Control\Lsa"
    $REG_CREDG_value = (Get-ItemProperty -Path $REG_CREDG).RunAsPPL

    #Set 'Account lockout threshold' to 1-10 invalid login attempts
    $NetAccounts = net accounts | select-string "lockout threshold" 
    if($netaccounts -like "*Never"){$netaccounts_Value = "0"} 

    #Turn on Microsoft Defender Application Guard managed mode
    if(((Get-computerinfo).OsTotalVisibleMemorySize /1024000) -gt "8") 
    {
        $DeviceGuard = (Get-WindowsOptionalFeature -Online -FeatureName Windows-Defender-ApplicationGuard).state
    } else {$DeviceGuard = "Not enough memory"}

    if (($REG_CREDG_value -ne "1"  -or $netaccounts_Value -eq "0" -or $DeviceGuard -eq "Disabled")){
        #Below necessary for Intune as of 10/2019 will only remediate Exit Code 1
        write-host "Start remediation"
        exit 1
    }
    else{
        #No matching certificates, do not remediate     
        exit 0
    }  
} catch{
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
    }
