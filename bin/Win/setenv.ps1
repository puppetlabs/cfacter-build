$first,$rest = $args
[Environment]::SetEnvironmentVariable("$first", "$rest", "Machine")
