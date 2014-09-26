$ErrorActionPreference = "Stop"
$env:PATH = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
& 'C:\Program Files (x86)\Git\bin\git.exe' $args
exit $lastexitcode