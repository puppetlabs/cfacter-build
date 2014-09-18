# =============================================================================
# This makefile is setup to build cfacter first building the
# cross-compiler suite (binutils, cross-compilers, cmake) followed by
# cfacter dependencies (boost, yaml, openssl)
# Threaded dependendencies are setup loosely following the opensolaris package
# maintainer best practices. Our directory structure is as follows
#
# ./
# ./source
# ./source/${arch:sparc,i386}.sysroot.tar.gz        -- contains sysroot headers
# ./source/<patches>
# ./source/$project_$version.tar.gz
# ./source/$project_$version/								-- generated from tar.gz
# ./build
# ./build/${arch:sparc,i386}
# ./build/${arch:sparc,i386}/$project_$version/
#
# The general steps (along with dependencies) are as follows (< needs)
#
# source/%.tar.gz
# 	< source/%/._.checkout
#	 		< source/%/._.patch
#	 		  ...  < source/%/._.sync  # not a standard target, Used for places where
#	 		                           # we need source in buld/$arch/%
#	 			< source/%/._.config
#	 				< source/%/._.make
#	 					< source/%/._.install
# =============================================================================
# Global definitions.
include Makefile.global
# -----------------------------------------------------------------------------

# ENTRY
all:
	@echo "usage:"
	@echo "sudo	$(MAKE) prepare -- creates the $(installroot) with permissions for current user"
	@echo "	$(MAKE) [arch={i386,sparc}] [getcompilers={make,fetch}] build  -- does a full build including compilers and depends"
	@echo "For updating compilers (for later builds - needs both sparc and i386 compilers installed)"
	@echo "	$(MAKE) gentoolchain"
	@echo "For using a prebuilt compiler:"
	@echo "	$(MAKE) toolchain [arch={i386,sparc}] getcompilers=fetch"
	@echo "install dependencies:"
	@echo "	$(MAKE) depends [arch={i386,sparc}]"
	@echo "compile cfacter:"
	@echo "	$(MAKE) cfacter [arch={i386,sparc}]"
	@echo "remove:"
	@echo "	$(MAKE) clean -- recursively cleans (* Only on full builds *)"
	@echo "	$(MAKE) clobber -- removes source/ build/ install/"
	@echo "sudo	$(MAKE) uninstall -- removes the $(installroot)"
	@echo
	@echo "info:"
	@echo "Solaris 10 dependencies are available from http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/"


# Project specific makefiles
# Use the generic as a template for new projects
include projects/Makefile.generic

# compiler suite
include projects/Makefile.binutils
include projects/Makefile.gcc
include projects/Makefile.cmake

# Dependencies
include projects/Makefile.boost
include projects/Makefile.yamlcpp
include projects/Makefile.openssl

# Our toolchain that uses compiler suite
include Makefile.toolchain

# CFacter tha tuses dependencies
include projects/Makefile.cfacter

# ENTRY
# Clean out our builds
clobber:
	rm -rf build install source build.log

clean: $(addprefix clean-,$(projects))
	rm -f build.log
	@echo $@ done

# ENTRY
# Clean out the installed packages. Unfortunately, we also need to
# redo the headers 
uninstall:
	rm -rf $(installroot)

prepare-10:
	wget -q -r -nH --cut-dirs=2 --no-parent --reject "index.html*" --no-check-certificate -c $(toolurl)/10/depends/
	echo "instance=overwrite\npartial=nocheck\nrunlevel=nocheck\nidepend=nocheck\nrdepend=nocheck\nspace=nocheck\nsetuid=nocheck\nconflict=nocheck\naction=nocheck\nbasedir=default" > depends/noask
	- (cd depends; for i in *; do pkginfo $$i || (echo a; yes) | pkgadd -d . -a noask $$i ; done)

prepare-11:
	-pkg install developer/gcc-45
	-pkg install system/header

# ENTRY
# This is to be the only command that requires `sudo` or root.
# Use `sudo gmake prepare` to invoke.
prepare: prepare-$(sys_rel)
	mkdir -p fetched
	rdate time.nist.gov
	mkdir -p $(installroot)
	chmod 777 $(installroot)

# ENTRY
get: $(get_)
	@echo $@ done

# ENTRY
checkout: $(checkout_)
	@echo $@ done

# To compile native cfacter, we can just build the native cross-compiler
# toolchain. However, to build the cross compiled sparc cfacter, we need to
# build the native toolchain first, getting us the native cmake, and build the
# cross compiled toolchain, and finally use both together to produce our
# cross-compiled cfacter

# ENTRY
build:
	$(MAKE) -e toolchain
	$(MAKE) -e depends
	$(MAKE) -e cfacter

# ENTRY
depends:
	@echo $@ done

$(mydirs): ; /bin/mkdir -p $@

# Asking make not to delete any of our intermediate touch files.
.PRECIOUS: $(get_) $(checkout_) $(patch_) \
	         $(config_) $(make_) $(install_)

.PHONY: build
