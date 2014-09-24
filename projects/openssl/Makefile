openssl_ver=1.0.0n
openssl_=openssl-$(openssl_ver)
projects+=$(openssl_)
names+=openssl

$(eval $(call standard_x,$(openssl_)))

depends: openssl

# ENTRY
openssl: install-$(openssl_)
	@echo $@ done

-include projects/openssl/Makefile.$(os)
