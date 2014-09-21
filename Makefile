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
include etc/Makefile.config
# -----------------------------------------------------------------------------

# ENTRY
all:
	@echo "Basic Usage: For an initial build"
	@echo "sudo $(MAKE) prepare; $(MAKE) build"
	@echo
	@echo "Basic Usage: For a completely clean build"
	@echo "sudo $(MAKE) uninstall prepare; $(MAKE) build"
	@echo
	@echo "Intermediate Usage:"
	@echo "sudo	$(MAKE) prepare"
	@echo "	The above command ensures that system paths are created with correct permissions for current user"
	@echo
	@echo "$(MAKE) [arch] [getcompilers={make,fetch}] build"
	@echo	"	This command accomplishes a build including compilers and depends"
	@echo
	@echo "$(MAKE) [arch] depends"
	@echo "	The above command installs dependencies for cfacter"
	@echo
	@echo "$(MAKE) [arch] $(cfacter_)"
	@echo "	The above command compiles cfacter"
	@echo
	@echo "$(MAKE) clean"
	@echo "	Recursively cleans (* Only on full builds *)"
	@echo "$(MAKE) clobber"
	@echo "	Removes source/ build/ install/"
	@echo "sudo	$(MAKE) uninstall"
	@echo "	Removes the $(installroot)"
	@echo
	@echo "Platform specific options:"
	@$(MAKE) all-$(os)


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
include etc/Makefile.toolchain

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
uninstall: uninstall-$(os)
	@echo done.

# ENTRY
# This is to be the only command that requires `sudo` or root.
# Use `sudo gmake prepare` to invoke.
prepare: prepare-$(os)
	$(synctime)

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

$(mydirs): ; $(mkdir) $@

# Asking make not to delete any of our intermediate touch files.
.PRECIOUS: $(get_) $(checkout_) $(patch_) \
	         $(config_) $(make_) $(install_)

.PHONY: build

include etc/Makefile.$(os)
