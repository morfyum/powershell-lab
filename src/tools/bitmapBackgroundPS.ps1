$code=@'
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int SystemParametersInfo(int uAction, int uParam, string IvParam, int fuWinInt);
'@

Add-Type -AssemblyName System.Drawing

$useThisBackground = "$env:HOMEPATH\Desktop\wpTest.jpg"
$savePath = "$env:HOMEPATH\Desktop\new_wallpaper.png"
$font = New-Object System.Drawing.Font("Segoue UI", 20)
$fontColor = "White"
$format = New-Object System.Drawing.StringFormat
$format.Alignment = [System.Drawing.StringAlignment]::Far

<# TODO INFO
(Get-CimInstance -ClassName Win32_VideoController)
 (Get-CimInstance -ClassName Win32_ComputerSystem)
#>
$systemDate = Get-Date -Format "yyyy-MM-dd HH:mm K"
$biosVerison = (Get-CimInstance -ClassName Win32_BIOS).SerialNumber
[int]$memorySizeInMB = ((Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory)/1024/1024
$unitModel = (Get-CimInstance -ClassName Win32_ComputerSystem).Model

if (Test-Path $useThisBackground) {
    $originalPicture = [System.Drawing.Image]::FromFile($useThisBackground)
    $bmp = New-Object System.Drawing.Bitmap($originalPicture.Width, $originalPicture.Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bmp)
    $graphics.DrawImage($originalPicture, 0, 0, $originalPicture.Width, $originalPicture.Height)
    $originalPicture.Dispose()
} else {
    $bmp = New-Object System.Drawing.Bitmap(1920, 1080)
    $graphics = [System.Drawing.Graphics]::FromImage($bmp)
    $graphics.Clear([System.Drawing.Color]::DarkRed) # DarkOrange
}

$farRight = $bmp.Width-20
#$height = 50
$graphics.DrawString("$systemDate", $font, [System.Drawing.Brushes]::$fontColor, $farRight, 50, $format)
$graphics.DrawString("Model : $unitModel", $font, [System.Drawing.Brushes]::$fontColor, $farRight, 100, $format)
$graphics.DrawString("BIOS  :$biosVerison", $font, [System.Drawing.Brushes]::$fontColor, $farRight, 150, $format)
$graphics.DrawString("Memory: $memorySizeInMB MB", $font, [System.Drawing.Brushes]::$fontColor, $farRight, 200, $format)


# Save new Image
$bmp.Save($savePath, [System.Drawing.Imaging.ImageFormat]::png)
Write-Host "New background saved to [$savePath]"

# Cleanup
$graphics.Dispose()
$font.Dispose()
$graphics.Dispose()
$bmp.Dispose()


function setAsBackground {
    param (
        [string]$ImagePath
    )

    # TODO if winPE 
    $regPath = "HKCU\Control Panel\Desktop"
    $winPeBackgroundPath = "X:\Windows\System32\winpe.jpg"
    Copy-Item -Path $ImagePath -Destination $winPeBackgroundPath
    Set-ItemProperty -Path $regPath -Name "Wallpaper" -Value $newWallpaper
    #Set-ItemProperty -Path $regPath -Name "WallpaperStyle" -Value 2  # 2 = Stretch

}