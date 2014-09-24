cmake_ver=3.0.0
cmake_=cmake-$(cmake_ver)
projects+=$(cmake_)
names+=cmake

$(eval $(call standard_x,$(cmake_)))

compiler: cmake

cmake: install-$(cmake_)
	@echo $@ done

-include projects/cmake/Makefile.$(os)
