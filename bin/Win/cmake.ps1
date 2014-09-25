$prefix,$first,$rest = $args
$gccbin="$prefix\gcc-4.8.2\bin"
$env:PATH = $gccbin + ";"+ [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

cd $first
& C:\ProgramData\chocolatey\bin\cmake.exe -G "MinGW Makefiles" $rest
