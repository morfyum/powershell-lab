# Create Personal CodeSigning Certification
New-SelfSignedCertificate -DnsName "Morfyum PowerShell LAB" -CertStoreLocation "Cert:\CurrentUser\My" -Type CodeSigning -KeyUsage DigitalSignature -KeyAlgorithm RSA -KeyLength 4096 -NotAfter (Get-Date).AddYears(10) -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3")

# Export Public & Private keys with: certmgr.msc => "C:\Windows\system32\Morfyum PowerShell LAB cert.pfx"
Get-Item "Cert:\CurrentUser\My\*"

# Import Certification 
Import-Certificate -FilePath C:\Temp\MyScriptSigningCert.cer -CertStoreLocation Cert:\LocalMachine\TrustedPublishers

# Get Certification into a variable
$cert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert | Where-Object {$_.Subject -like "*Morfyum PowerShell LAB*"}
# Sign my Script 
Set-AuthenticodeSignature -FilePath "C:\path\to\your_script.ps1" -Certificate $cert