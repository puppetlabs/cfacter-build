# TODO I dont know how to set the environment variable in make
# This should be the $prefix\... variable
$gccbin="c:\cfacter\64\gcc-4.8.2\bin"
$env:PATH = $gccbin + ";"+ [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

$first,$rest = $args
cd $first
& C:\ProgramData\chocolatey\bin\cmake.exe -G "MinGW Makefiles" $rest
