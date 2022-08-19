function Get-Video {
$video = Get-CimInstance -ClassName win32_videocontroller | select Description, VideoProcessor, VideoModeDescription | Format-List
$video
}

Get-Video