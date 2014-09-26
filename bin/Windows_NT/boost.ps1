$ErrorActionPreference = "Stop"
$prefix,$first,$rest = $args
cd $first
$env:PATH = [System.Environment]::GetEnvironmentVariable("CCPath","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
.\bootstrap mingw
.\b2 $rest
exit $lastexitcode