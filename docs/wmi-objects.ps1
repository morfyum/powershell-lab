
# WINDOWS LICENSE KEY (DPK) 
## RunAs Admin. IfEmpty -> no Product Key!
(Get-WmiObject -query ‘select * from SoftwareLicensingService’).OA3xOriginalProductKey

#
# Get-WmiObject DOCS:
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-wmiobject?view=powershell-5.1
#
# List of Win32_Objects:
# https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-motherboarddevice


# BIOS INFORMATIONS:
Get-WmiObject -Class Win32_Bios | Format-List -Property *
Get-WmiObject -Class Win32_Bios
(Get-WmiObject -Class Win32_Bios).SMBIOSBIOSVersion


