cfacter-build
=============
## Basics

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
