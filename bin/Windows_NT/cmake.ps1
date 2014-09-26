$ErrorActionPreference = "Stop"
$prefix,$first,$rest = $args
$env:PATH = [System.Environment]::GetEnvironmentVariable("CCPath","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

cd $first
& C:\ProgramData\chocolatey\bin\cmake.exe -G "MinGW Makefiles" $rest
exit $lastexitcode