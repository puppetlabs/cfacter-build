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
#
# IMPORTANT
# 	If you introduce a new recipe, make sure to only specify the particular
# 	`actions` that you need to take, and define the action elsewhere. For
# 	example, to remove a file/folder, define _remove_ and then define remove
# 	in Makefile.config as rm -rf. This way, you can override them later in
# 	your platform config file. Remember, you can override variables, but
# 	overriding full recipes is discouraged (but specialization of pattern
# 	rules is allowed).
#
# =============================================================================
# Global definitions.
include etc/config/Makefile
# -----------------------------------------------------------------------------

# ENTRY
all:
	$(cat) USAGE.md
	@$(echo) "Platform specific options:"
	@$(MAKE) all-$(os)


# Project specific makefiles
# Use the generic as a template for new projects
include etc/Makefile.generic

# Projects
include etc/build/Makefile.$(os)

# toolchain
include etc/toolchain/Makefile.$(os)

# CFacter tha tuses dependencies
include projects/cfacter/Makefile

# ENTRY
# Clean out our builds
clobber:
	- $(remove) build
	- $(remove) install
	- $(remove) source
	- $(remove) build.log

clean: $(addprefix clean-,$(projects))
	- $(remove) build.log
	@$(echo) $@ done

# ENTRY
# Clean out the installed packages. Unfortunately, we also need to
# redo the headers 
uninstall: uninstall-$(os)
	@$(echo) done.

# ENTRY
# This is to be the only command that requires `sudo` or root.
# Use `sudo gmake prepare` to invoke.
prepare: prepare-$(os)
	$(synctime)

# ENTRY
get: $(get_)
	@$(echo) $@ done

# ENTRY
checkout: $(checkout_)
	@$(echo) $@ done

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

install: install-$(os)
	@$(echo) done

# ENTRY
depends:
	@$(echo) $@ done

$(mydirs): ; $(mkdir) $@

# Asking make not to delete any of our intermediate touch files.
.PRECIOUS: $(get_) $(checkout_) $(patch_) \
	         $(config_) $(make_) $(install_)

.PHONY: build install

include etc/Makefile.$(os)
