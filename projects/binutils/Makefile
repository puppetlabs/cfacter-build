binutils_ver=2.23.2
binutils_=binutils-$(binutils_ver)
projects+=$(binutils_)
names+=binutils

$(eval $(call standard_x,$(binutils_)))

compiler: binutils

# ENTRY
binutils: install-$(binutils_)
	@$(echo) $@ done

-include projects/binutils/Makefile.$(os)

