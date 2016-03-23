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
		 wid.sh \
		 windows.sh \
		 winkill.sh \
		 winopen.sh \

.PHONY: all install uninstall

all: install

install: $(SCRIPT)
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f $(SCRIPT) $(DESTDIR)$(PREFIX)/bin

uninstall:
	@for script in $(SCRIPT); do \
		rm $(DESTDIR)$(PREFIX)/bin/$$script; \
	done
