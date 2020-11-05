##Intune-Decode-Base64.ps1## 
$Base64Code = read-host 'fill in the .txt file containing the base64 code to decode' 
$Code = Get-Content $Base64Code [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($Code))| ` 
out-file -Encoding "ascii" output.ps1 
notepad.exe .\output.ps1