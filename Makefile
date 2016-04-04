PREFIX = /usr/local
MANDIR = /usr/share/man
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
		 pather \
		 position \
		 power \
		 runfyre \
		 setborder \
		 resize \
		 snap \
		 taskbar \
		 wid \
		 windows \
		 winkill \
		 winopen

CONFIG  = config.example
FYREDIR = $(shell echo $$HOME)/.config/fyre

.PHONY: all link config install uninstall

all: link config

link: $(SCRIPT)
	@for script in $(SCRIPT); do \
		ln -svfn $(shell pwd)/$$script $(PREFIX)/bin ; \
	done

config: $(CONFIG)
	@test -d $(FYREDIR) || mkdir -p $(FYREDIR)
	ln -svfn $(shell pwd)/$(CONFIG) $(FYREDIR)/config

install: $(SCRIPT)
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f $(SCRIPT) $(DESTDIR)$(PREFIX)/bin

uninstall:
	@for script in $(SCRIPT); do \
		rm $(DESTDIR)$(PREFIX)/bin/$$script; \
	done
