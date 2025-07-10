. .\debitlocker.ps1

SetCompactMode
$STATES = GetBitlockerStatus
#$STATES.Add("D:", 100)
ShowState -VolumeList $STATES
Pause