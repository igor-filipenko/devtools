
DESTDIR = $HOME

EXECUTED = $(wildcard src/set-%)
UTILS = common.sh deploy.sh setretail10.mk config
JARS = $(wildcard share/%.jar)

.PHONY jars scripts executed utils config

all: jars scripts config

scripts: executed utils

config:
ifeq (,$(wildcard $HOME/.devtools))
	cp devtools.template $HOME/.devtools
endif

executed: | $(DESTDIR)/bin
	cp $(EXECUTED) $|

utils: | $(DESTDIR)/share
	cp $(UTILS) $|

jars: | $(DESTDIR)/share
	cp $(JARS) $|

$(DESTDIR)/bin:
	mkdir -p $@
