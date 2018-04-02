
include $(HOME)/.devtools

SRCDIR=$(HOME)/src/setretail10
DSTDIR=/srv
GRADLEPREFIX=build/libs
SERVERDEPLOYDIR=deployments/Set10.ear
FORCE=FORCE
QUIET=@

CENTRUMDIR=$(DSTDIR)/centrum/$(SERVERDEPLOYDIR)
RETAILDIR=$(DSTDIR)/retail/$(SERVERDEPLOYDIR)
CASHDIR=$(DSTDIR)/cash


.PHONY: all $(FORCE)

# Setup server and cach jar component
# 1 - module name (jar file name without suffix)
# 2 - source directory
# 3 - server destination directory (may be empty)
# 4 - cach destination directory (may be empty)
define JAR

.PHONY: $(1)

all: $(1)

## If server destination directory set
ifneq (,$(3))

# If CENTRUM mounted
ifneq (,$$(wildcard $(CENTRUMDIR)/$(3)/$(1).jar))

$(1): $(CENTRUMDIR)/$(3)/$(1).jar

$(CENTRUMDIR)/$(3)/$(1).jar: $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).jar
	@echo "Install on CENTRUM..."
	$$(QUIET)cp $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).jar $(CENTRUMDIR)/$(3)/$(1).jar

else

$$(warning $(CENTRUMDIR)/$(3)/$(1).jar not found on CENTRUM!)

endif # centrum mounted

# If RETAIL mounted
ifneq (,$$(wildcard $(RETAILDIR)/$(3)/$(1).jar))

$(1): $(RETAILDIR)/$(3)/$(1).jar

$(RETAILDIR)/$(3)/$(1).jar: $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).jar
	@echo "Install on RETAIL..."
	$$(QUIET)cp $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).jar $(RETAILDIR)/$(3)/$(1).jar

else

$$(warning $(RETAILDIR)/$(3)/$(1).jar not found on RETAIL!)

endif # retail mounted

endif # server destination

## If cach destination directory set
ifneq (,$(4))

# If CASH mounted
ifneq (,$$(wildcard $(CASHDIR)/$(4)/$(1).jar))

$(1): $(CASHDIR)/$(4)/$(1).jar

$(CASHDIR)/$(4)/$(1).jar: $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).jar
	@echo "Install on CASH..."
	$$(QUIET)cp $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).jar $(CASHDIR)/$(4)/$(1).jar

else

$$(warning CASH not mounted!)

endif # cash mounted

endif # cash destination

## Build JAR file from sources
$(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).jar: $$(FORCE)
	$$(QUIET)cd $(SRCDIR)/$(2) && gradle clean jar

endef


# Setup server war component
# 1 - module name (war file name without suffix)
# 2 - source directory
# 3 - server destination directory (may be empty)
define WAR

.PHONY: $(1)

all: $(1)

## If server destination directory set
ifneq (,$(3))

# If CENTRUM mounted
ifneq (,$$(wildcard $(CENTRUMDIR)/$(3)/$(1).war))

$(1): $(CENTRUMDIR)/$(3)/$(1).war

$(CENTRUMDIR)/$(3)/$(1).war: $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).war
	@echo "Install on CENTRUM..."
	$$(QUIET)cp $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).war $(CENTRUMDIR)/$(3)/$(1).war

else

$$(warning $(CENTRUMDIR)/$(3)/$(1).war not found on CENTRUM!)

endif # centrum mounted

# If RETAIL mounted
ifneq (,$$(wildcard $(RETAILDIR)/$(3)/$(1).war))

$(1): $(RETAILDIR)/$(3)/$(1).war

$(RETAILDIR)/$(3)/$(1).war: $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).war
	@echo "Install on RETAIL..."
	$$(QUIET)cp $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).war $(RETAILDIR)/$(3)/$(1).war

else

$$(warning $(RETAILDIR)/$(3)/$(1).war not found on RETAIL!)

endif # retail mounted

endif # server destination

## Build WAR file from sources
$(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).war: $$(FORCE)
	$$(QUIET)cd $(SRCDIR)/$(2) && gradle clean war

endef
