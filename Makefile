# Makefile for mdns-repeater


ZIP_NAME = mdns-repeater-$(VCSVERSION)

ZIP_FILES = mdns-repeater	\
			README.txt		\
			LICENSE.txt

VCSVERSION=$(shell git describe --dirty="-SNAPSHOT" --always --tags)

CFLAGS=-Wall

ifdef DEBUG
CFLAGS+= -g
else
CFLAGS+= -Os
LDFLAGS+= -s
endif

CFLAGS+= -DVCSVERSION="\"${VCSVERSION}\""

.PHONY: all clean

all: mdns-repeater

mdns-repeater.o: _version

mdns-repeater: mdns-repeater.o

.PHONY: zip
zip: TMPDIR := $(shell mktemp -d)
zip: mdns-repeater
	mkdir $(TMPDIR)/$(ZIP_NAME)
	cp $(ZIP_FILES) $(TMPDIR)/$(ZIP_NAME)
	-$(RM) $(CURDIR)/$(ZIP_NAME).zip
	cd $(TMPDIR) && zip -r $(CURDIR)/$(ZIP_NAME).zip $(ZIP_NAME)
	-$(RM) -rf $(TMPDIR)

# version checking rules
.PHONY: dummy
_version: dummy
	@echo $(VCSVERSION) | cmp -s $@ - || echo $(VCSVERSION) > $@

clean:
	-$(RM) *.o
	-$(RM) _version
	-$(RM) mdns-repeater
	-$(RM) mdns-repeater-*.zip

