################################################################################
#
# psysh
#
################################################################################

PSYSH_VERSION = 2.52
PSYSH_SITE = https://psysh.org/
PSYSH_SOURCE = nled_2_52_src.tgz
PSYSH_LICENSE = MIT
PSYSH_INSTALL_STAGING = YES
PSYSH_DEPENDENCIES = php

# We need to override the C compiler used in the Makefile to 
# use buildroot's cross-compiler instead of cc.  Switch cc to $(CC)
# so we can override the variable via env vars.
define PSYSH_MAKEFILE_FIXUP
	$(SED) 's/cc $$(CCOPTIONS)/$$(CC) -static $$(CPPFLAGS) $$(CFLAGS) -c/g' $(@D)/Makefile
	$(SED) 's/cc -o/$$(CC) $$(LDFLAGS) -o/g' $(@D)/Makefile
endef

PSYSH_PRE_BUILD_HOOKS += PSYSH_MAKEFILE_FIXUP

define PSYSH_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) LIBS="$(TARGET_CFLAGS)"
endef

define PSYSH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/psysh $(TARGET_DIR)/usr/bin/psysh
endef

define PSYSH_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/psysh $(STAGING_DIR)/usr/bin/psysh
endef

$(eval $(generic-package))
