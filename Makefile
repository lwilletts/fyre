PREFIX = /usr/local
MANDIR = /usr/share/man
SCRIPT = blur.sh \
		 closest.sh \
		 eventually.sh \
		 focus.sh \
		 fullscreen.sh \
		 fyrerc.sh \
		 ignore.sh \
		 layouts.sh \
		 LICENSE.md \
		 Makefile \
		 mouse.sh \
		 move.sh \
		 position.sh \
		 power.sh \
		 README.md \
		 runfyre.sh \
		 setborder.sh \
		 size.sh \
		 snap.sh \
		 sxhkdc.example \
		 taskbar.sh \
		 wgroups.sh \
		 wid.sh \
		 windows.sh \
		 winopen.sh \

.PHONY: all install uninstall

all: install

install:
	for i in $(SCRIPT); do \
		install -Dm755 $$i $(DESTDIR)$(PREFIX)/bin/$$i; \
	done

uninstall:
	for i in $(SCRIPT); do \
		rm $(DESTDIR)$(PREFIX)/bin/$$i; \
	done
