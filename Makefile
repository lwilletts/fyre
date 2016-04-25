PREFIX ?= /usr/local
MANDIR ?= $(PREFIX)/share/man
SCRIPT = back \
		 closest \
		 eventually \
		 focus \
		 fullscreen \
		 fyrerc \
		 hover \
		 layouts \
		 mouse \
		 move \
		 position \
		 power \
		 runfyre \
		 sizesnap \
		 snap \
		 wid \
		 windows \
		 winkill \
		 winopen

CONFIGDIR = $(shell echo $$HOME)/.config/fyre
CONFIG  = extra/config.example

.PHONY: all link config install uninstall

all: link

link: $(SCRIPT)
	@for script in $(SCRIPT); do \
		ln -svfn $(shell pwd)/$$script $(PREFIX)/bin ; \
	done

config: $(CONFIG)
	@test -d $(CONFIGDIR) || mkdir -p $(CONFIGDIR)
	cp $(CONFIG) $(CONFIGDIR)/config

install: $(SCRIPT)
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f $(SCRIPT) $(DESTDIR)$(PREFIX)/bin

uninstall:
	@for script in $(SCRIPT); do \
		rm $(DESTDIR)$(PREFIX)/bin/$$script; \
	done
