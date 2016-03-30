PREFIX = /usr/local
MANDIR = /usr/share/man
SCRIPT = blur \
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
		 screens \
		 setborder \
		 resize \
		 snap \
		 taskbar \
		 wid \
		 windows \
		 winkill \
		 winopen

.PHONY: all link install uninstall

all: link

link: $(SCRIPT)
	@for script in $(SCRIPT); do \
		ln -svfn $(shell pwd)/$$script $(PREFIX)/bin ; \
	done

install: $(SCRIPT)
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f $(SCRIPT) $(DESTDIR)$(PREFIX)/bin

uninstall:
	@for script in $(SCRIPT); do \
		rm $(DESTDIR)$(PREFIX)/bin/$$script; \
	done
