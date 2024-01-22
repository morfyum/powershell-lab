# keepawake from: https://gist.github.com/jamesfreeman959/231b068c3d1ed6557675f21c0e346a9c
$wsh = New-Object -ComObject WScript.Shell
while (1) {
  # Other method with mouse movin:
  #$Pos = [System.Windows.Forms.Cursor]::Position
  #[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point((($Pos.X) + 1), $Pos.Y)
  # Send Shift+F15 - this is the least intrusive key combination I can think of and is also used as default by:
  $wsh.SendKeys('+{F15}')
  cls
  Write-Host "^_^"
  Start-Sleep -seconds 59
}
