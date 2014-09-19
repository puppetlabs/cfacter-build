cfacter-build
=============
## Basics

Feel free to stop and restart at any point of time. The build will restart at exactly the point it left off.

### Prepare

For S10
```
s10# /opt/csw/bin/pkgutil -y -i git
s10# /opt/csw/bin/pkgutil -y -i tmux  # optional
```

For s11
```
s11# pkg install git
```

#### Checkout
```
git clone https://github.com/puppetlabs/cfacter-build
```


### Prepare
```
cd cfacter-build
sudo gmake prepare
```

### Build it
```
gmake build
```

### Now for sparc
```
gmake build arch=sparc
```

The cfacter gets built in `./build/<arch>/cfacter-<ver>`

If you are developing cfacter, then it may be better to
fetch from your own repository, in which case, use the variable cfacter_clone like so
```
gmake build cfacter_clone=git@github.com:puppetlabs/cfacter.git
```

## Intermediate

### Uninstall all we installed
```
sudo gmake uninstall
```
### Return to the check-out state
```
gmake clobber
```

I typically invoke `sudo gmake uninstall prepare; gmake clobber` to start anew.

## Advanced
### Logging

To turn off the logging to build.log
```
gmake build nolog=1
```
You might also want to look at `Makefile.global::t` to customize other
output options. e.g `gmake build t=" && echo "` for the above effect.

### Adding a new dependency

Copy `projects/Makefile.<e.g>` to your own project, and modify variables
accordingly. We have examples of both `autoconf` and `cmake` builds.

Notice that there are two targets: `compiler` and `depends`.
The compiler target is used to add a new dependency to the compiler while
depends is used to add dependency to the cfacter itself. So if you want
to add a project as cfacter dependency, use `depends: <myproject>` in your
make file.

Be sure to read the `projects/Makefile.generic`. It contains the default
rules for building the project. If your dependency follows the standard
build procedure, you can get by using just the base rules, but if it
requires specific handling, you may need to specialize the pattern rules
for your project.

#### Adding patches

All patches that are in the `patches/` directory, with the format 
`<project>-<version>-***.patch` will be applied correctly to the project
named by the standard pattern rule.
