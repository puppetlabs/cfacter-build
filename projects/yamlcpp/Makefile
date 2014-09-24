yamlcpp_ver=0.5.1
yamlcpp_=yaml-cpp-$(yamlcpp_ver)
projects+=$(yamlcpp_)
names+=yaml-cpp

$(eval $(call standard_x,$(yamlcpp_)))

depends: yaml-cpp

# ENTRY
yaml-cpp: install-$(yamlcpp_)
	@echo $@ done

-include projects/yamlcpp/Makefile.$(os)
