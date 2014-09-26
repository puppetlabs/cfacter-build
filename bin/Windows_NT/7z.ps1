$ErrorActionPreference = "Stop"
& 'C:\Program Files\7-Zip\7z.exe' x -aoa $args
exit $lastexitcode