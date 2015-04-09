boost_ver=1_57_0
boost_=boost_$(boost_ver)
projects+=$(boost_)
names+=boost

$(eval $(call standard_x,$(boost_)))

depends: boost

# ENTRY
boost: install-$(boost_)
	@$(echo) $@ done

-include projects/boost/Makefile.$(os)
