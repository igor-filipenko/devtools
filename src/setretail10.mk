
include $(HOME)/.devtools

DESTDIR?=
GOALS?=clean
QUIET?=@

SRCDIR=.
DSTDIR=/srv
GRADLEPREFIX=build/libs
SERVERDEPLOYDIR=deployments/Set10.ear
GRADLE=gradle -q
FORCE=FORCE

CENTRUMDIR=$(DSTDIR)/centrum/$(SERVERDEPLOYDIR)
RETAILDIR=$(DSTDIR)/retail/$(SERVERDEPLOYDIR)
CASHDIR=$(DSTDIR)/cash


.PHONY: all $(FORCE) help

all:

help:
		@echo "This makefile can speed up building and deploying jars."
		@echo "Use DESTDIR variable if need to build hot jars."
		@echo "Use GOALS to specify other gradle target, by default: $(GOALS)."
		@echo "Example:"
		@echo "\tGOALS=\"clean test\" DESTDIR=/tmp make DataStructModule"

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

## If patch destination not set
ifeq (,$(DESTDIR))

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

ifeq (,$(DESTDIR))
$$(warning $(RETAILDIR)/$(3)/$(1).jar not found on RETAIL!)
endif

endif # retail mounted

else

$(1): $(DESTDIR)/$(1).jar

$(DESTDIR)/$(1).jar: $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).jar
	@echo "Copy jars to $(DESTDIR)"
	@mkdir -p $(DESTDIR)
	$$(QUIET)cp $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).jar $(DESTDIR)/$(1).jar

endif # patch destination

endif # server destination

## If cach destination directory set
ifneq (,$(4))

## If patch destination not set
ifeq (,$(DESTDIR))

# If CASH mounted
ifneq (,$$(wildcard $(CASHDIR)/$(4)/$(1).jar))

$(1): $(CASHDIR)/$(4)/$(1).jar

$(CASHDIR)/$(4)/$(1).jar: $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).jar
	@echo "Install on CASH..."
	$$(QUIET)cp $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).jar $(CASHDIR)/$(4)/$(1).jar

else

$$(warning CASH not mounted!)

endif # cash mounted

else

ifeq (,$(3)) # if cash only

$(1): $(DESTDIR)/$(1).jar

$(DESTDIR)/$(1).jar: $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).jar
	@echo "Copy jars to $(DESTDIR)"
	@mkdir -p $(DESTDIR)
	$$(QUIET)cp $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).jar $(DESTDIR)/$(1).jar

endif

endif # patch destination

endif # cash destination

## Build JAR file from sources
$(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).jar: $$(FORCE)
	$$(QUIET)cd $(SRCDIR)/$(2) && $(GRADLE) $(GOALS) jar

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

## If patch destination not set
ifeq (,$(DESTDIR))

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

ifeq (,$(DESTDIR))
$$(warning $(RETAILDIR)/$(3)/$(1).war not found on RETAIL!)
endif

endif # retail mounted

else

$(1): $(DESTDIR)/$(1).war

$(DESTDIR)/$(1).war: $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).war
	@echo "Copy jars to $(DESTDIR)"
	@mkdir -p $(DESTDIR)
	$$(QUIET)cp $(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).war $(DESTDIR)/$(1).war

endif # patch destination

endif # server destination

## Build WAR file from sources
$(SRCDIR)/$(2)/$(GRADLEPREFIX)/$(1).war: $$(FORCE)
	$$(QUIET)cd $(SRCDIR)/$(2) && $(GRADLE) $(GOALS) war

endef
