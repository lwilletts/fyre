PREFIX = /usr/local
MANDIR = /usr/share/man
SCRIPT = blur.sh \
		 closest.sh \
		 eventually.sh \
		 focus.sh \
		 fullscreen.sh \
		 fyrerc.sh \
		 hover.sh \
		 ign.sh \
		 layouts.sh \
		 mouse.sh \
		 move.sh \
		 position.sh \
		 power.sh \
		 runfyre.sh \
		 screens.sh \
		 setborder.sh \
		 size.sh \
		 snap.sh \
		 taskbar.sh \
		 underneath.sh \
		 wid.sh \
		 windows.sh \
		 winkill.sh \
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
