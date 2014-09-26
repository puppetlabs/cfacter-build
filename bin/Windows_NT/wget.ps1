$ErrorActionPreference = "Stop"
$dest = [System.IO.Path]::GetFileName($args[0])
(New-Object net.webclient).DownloadFile($args[0], $dest)
