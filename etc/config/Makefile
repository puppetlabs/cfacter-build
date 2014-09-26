#  The general variables that may be modified from the environment. The most
#  important is the arch changes whether a native compiler or a cross-compiler
#  is built.

# Since we dont recurse into subdirs, we can use CURDIR for the root path.
rootdir:=$(CURDIR)

ifndef os
arch?=$(shell /usr/bin/uname -p)
kernel?=$(shell /usr/bin/uname -s)
os?=$(kernel)-$(arch)
else
arch?=x
endif
# -----------------------------------------------------------------------------
# Name of the operating system where you are _building_. If the platform does not
# have uname, then pass in the operating system name directly


# -----------------------------------------------------------------------------
# These are the projects we are currently building. Where possible, try to
# follow the $project-$ver format, if not, use the boost example.

projects=
# -----------------------------------------------------------------------------
# need the label for making tar balls.
installlabel=pl-build-tools
# -----------------------------------------------------------------------------
# The URL from where we get most of our sources.
sourceurl=http://enterprise.delivery.puppetlabs.net/sources/$(os)
toolurl=https://pl-build-tools.delivery.puppetlabs.net/$(os)

# -----------------------------------------------------------------------------
# how we want to get our compiler suite?
# use `gmake getcompilers=fetch __` to get it from the precompiled tarballs in
# remote repo. Use `gmake getcompilers=make __` to make use of locally
# compiled suite.

getcompilers:=fetch
export getcompilers

# The source/ directory ideally should not contain arch dependent files since
# it is used mostly for extracting sources. On the other hand, our builds have
# separate directories for each $arch
builds=$(addprefix build/$(arch)/,$(projects))
installs=$(addprefix install/$(arch)/,$(projects))
source=$(addprefix source/,$(projects))
fetched=$(addprefix fetched/,$(projects))

# our touch files, which indicate that specific actions have completed
# without errors.

get_=$(addprefix fetched/,$(addsuffix .tar.gz,$(projects)))
checkout_=$(addsuffix /._.checkout,$(addprefix source/,$(projects)))
patch_=$(addsuffix /._.patch,$(addprefix source/,$(projects)))
config_=$(addsuffix /._.config,$(addprefix build/$(arch)/,$(projects)))
make_=$(addsuffix /._.make,$(addprefix build/$(arch)/,$(projects)))
install_=$(addsuffix /._.install,$(addprefix install/$(arch)/,$(projects)))

toolchain_=$(addsuffix ._.cmakeenv, source/$(arch)/)

# -----------------------------------------------------------------------------
#  Common utilities. Override them in platform specific makefiles.

# Remove all
remove=/bin/rm -rf
echo=echo
timeserver=time.nist.gov
synctime=$(rdate) $(timeserver)
cat=/bin/cat
mkdir=/bin/mkdir -p
wget_=/usr/bin/wget
wget=$(wget_) -q -c --no-check-certificate
fetchdir=$(wget) -r -nH --cut-dirs=2 --no-parent --reject "index.html*" --no-check-certificate
git=/usr/bin/git
move=/bin/mv
touch=/bin/touch
extractgz=/bin/bash -c 'cat $$0 | (cd source/ && $(gzip) -dc | $(tar) -xf - )'
patchall=/bin/bash -c 'set +o pipefail; cat -s patches/$$0-* | (cd $$1 && $(patch) -p1 )'
syncdir=/bin/bash -c '(cd $$0 && $(tar) -cf - . ) | (cd $$1 && $(tar) -xf -)'
tgz=tar.gz


ar=/usr/bin/ar
tar=/usr/bin/tar
gzip=/usr/bin/gzip
bzip2=/usr/bin/bzip2
patch=/usr/bin/patch
rsync=/usr/bin/rsync
rdate=/usr/bin/rdate
chmod=/bin/chmod


as=/usr/bin/as
ld=/usr/bin/ld
cmake=/usr/bin/cmake
cmakecmd=$(cmake) $(withtoolchain) $(cmakeverbose)
# -----------------------------------------------------------------------------
# $mydirs, and the make rule make sure that our directories are created before
# they are needed. To make use of this, add the directory here, and in the
# target, use `<target>: | <dirname>` incantation to ensure that the directory
# exists. (Notice the use of '|' to ensure that our targets do not get rebuilt
# unnecessarily)

mydirs=source install/$(arch) fetched $(source) $(builds) $(installs) \
			 build/$(arch)  source/$(arch) \
			 source/$(arch)/root $(sysdirs) \
			 source/cfacter build/$(arch)/cfacter
# -----------------------------------------------------------------------------
# some trickery to use array path elements
e:=
space:=$(e) $(e)
path= /usr/bin \
		 /bin \
		 /sbin \
		 /usr/sbin

# ensure that the path is visible to our build as a shell environment variable.
export PATH=$(subst $(space),:,$(path))

withtoolchain=-DCMAKE_TOOLCHAIN_FILE=$(prefix)/$(os)-toolchain.cmake
cmakeverbose=-DCMAKE_VERBOSE_MAKEFILE=ON

# Make bash sane.
# And dont use /bin/sh if you can help it.
export SHELL=/bin/bash -e -o pipefail

# redirect config make & make install output to a build.log
# Use this if you dislike redirecting to logs
t=2>&1 | tee -a build.log >
ifdef nolog
t= && echo
endif

# Give platform specific definitions a chance to override.
include etc/config/Makefile.$(os)
