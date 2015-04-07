facter_ver=0
facter_=facter-$(facter_ver)
projects+=$(facter_)
names+=facter
facter_clone=https://github.com/puppetlabs/facter

$(eval $(call standard_x,$(facter_)))

program: facter

facter: build/$(arch)/$(facter_)/._.make
	@$(echo) $@ done

-include projects/facter/Makefile.$(os)
