[CmdletBinding()]
Param (
       [Parameter(Mandatory=$true)][String]$TenantName
)

$authParams = @{
clientId = '53405005-160e-44e4-a86a-8feb23429cf6' #well known intune / graph application
tenantId = "$TenantName"
Interactive = $true
DeviceCode = $true
}
$token = Get-MsalToken @authParams

$graphApiVersion = "beta";
$resource = "/deviceManagement/deviceManagementScripts";
$headers = @{
    "Authorization" = "Bearer $($token.AccessToken )";
    "Content-Type" = "application/json";
}

#region Get all device policies
$Scripts = Invoke-RestMethod -Uri "https://graph.microsoft.com/$($graphApiVersion)/$($resource)" -Method Get -Headers $headers -UseBasicParsing;
"Found $($Scripts.value.Count) script";
$ContentID = ($scripts.value | select DisplayName,ID | out-gridview -PassThru).ID
$Content = Invoke-RestMethod -Uri "https://graph.microsoft.com/$($graphApiVersion)/$($resource)/$ContentID" -Method Get -Headers $headers -UseBasicParsing;

#Decrypt Base64 and export
$EncodedText = $content.scriptcontent
$DecodedText = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($EncodedText))
$DecodedText | out-file $env:temp\PowerShell-script.ps1 -Force

Notepad.exe $env:temp\PowerShell-script.ps1
