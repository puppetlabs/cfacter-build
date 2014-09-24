cfacter_ver=0
cfacter_=cfacter-$(cfacter_ver)
projects+=$(cfacter_)
names+=cfacter
cfacter_clone=http://github.com/puppetlabs/cfacter

$(eval $(call standard_x,$(cfacter_)))

program: cfacter

cfacter: build/$(arch)/$(cfacter_)/._.make
	@echo $@ done

-include projects/cfacter/Makefile.$(os)
