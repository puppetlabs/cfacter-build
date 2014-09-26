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
You might also want to look at `etc/config/Makefile::t` to customize other
output options. e.g `gmake build t=" && echo "` for the above effect.

### Adding a new dependency

Copy `projects/<e.g>/Makefile` to your own project, and modify variables
accordingly. We have examples of both `autoconf` and `cmake` builds.

Notice that there are two targets: `compiler` and `depends`.
The compiler target is used to add a new dependency to the compiler while
depends is used to add dependency to the cfacter itself. So if you want
to add a project as cfacter dependency, use `depends: <myproject>` in your
make file.

Be sure to read the `etc/Makefile.generic`. It contains the default
rules for building the project. If your dependency follows the standard
build procedure, you can get by using just the base rules, but if it
requires specific handling, you may need to specialize the pattern rules
for your project.

#### Adding patches

All patches that are in the `patches/` directory, with the format 
`<project>-<version>-***.patch` will be applied correctly to the project
named by the standard pattern rule.

#### Adding a new operating system

cfacter-build chooses the operating system for the build from the value
of `os`, and `arch` variables. This may be passed in from command line as
`gmake os=XX arch=xx` for those platforms that do not have `uname` or
equivalent. If not passed in,
cfacter-build tries to figure out the operating system using `uname`, and
includes `<Makefile>.$(os)` versions of each makefile. These are included
at the end of each `<Makefile>` so that any definition may be overridden.

Insepct the `etc/config/Makefile`, and add any variables to be overridden or
new variables required for compilation, that is not relevant to other OS 
to `etc/config/Makefile.<youros>`. You can try doing the same for
`etc/toolchain/Makefile.<os>` or other Makefiles too. Ensure that the last
line is `include <MakefilePath>.$(os)`
if you are overriding variables in a Makefile.

The same procedure applies to Makefiles under `projects`. But here, include your
new makefile at the end of the particular project makefile as
`-include projects/<project>/Makefile.$(os)`

If you are adding a dependency project, then edit `etc/build/Makefile.<os>`
and add it to the list of project specific Makefiles, as
`include projects/<myproject>/Makefile`.

Windows
-------
We use powershell as the base, so execute the commands on a powershell window.

For windows platforms, start with choco
```
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
```
Install `git` and `make`
```
choco install git
choco install make
```
Restart the powershell at this point for git and make to register itself in the path

Get the repository
```
git clone https://github.com/puppetlabs/cfacter-build
```
Prepare
```
make prepare
```
And build
```
make build
```
Installation puts `cfacter.exe` in installroot along with required dlls
```
make install
```
If you build with `BOOST_PRE=1`, then a prebuilt boost is used instead of building it.
