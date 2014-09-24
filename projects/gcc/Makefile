gcc_ver=4.8.2
gcc_=gcc-$(gcc_ver)
projects+=$(gcc_)
names+=gcc

$(eval $(call standard_x,$(gcc_)))

compiler: gcc

# ENTRY
gcc: install-$(gcc_)
	@echo $@ done

-include projects/gcc/Makefile.$(os)

