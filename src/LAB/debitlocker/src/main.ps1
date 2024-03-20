. .\debitlocker.ps1

$STATES = GetBitlockerStatus
#$STATES.Add("D:", 100)
ShowState -VolumeList $STATES
Pause