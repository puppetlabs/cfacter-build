$ErrorActionPreference = "Stop"
$env:PATH = [System.Environment]::GetEnvironmentVariable("CCPath","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
$first,$rest = $args
& "$first" $rest
exit $lastexitcode