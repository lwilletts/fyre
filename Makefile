PREFIX = /usr/local
MANDIR = /usr/share/man

install:
	install -Dm755 blur.sh $(DESTDIR)$(PREFIX)/bin/blur.sh
	install -Dm755 closest.sh $(DESTDIR)$(PREFIX)/bin/closest.sh
	install -Dm755 focus.sh $(DESTDIR)$(PREFIX)/bin/focus.sh
	install -Dm755 fullscreen.sh $(DESTDIR)$(PREFIX)/bin/fullscreen.sh
	install -Dm755 fyrerc.sh $(DESTDIR)$(PREFIX)/bin/fyrerc.sh
	install -Dm755 ignore.sh $(DESTDIR)$(PREFIX)/bin/ignore.sh
	install -Dm755 layouts.sh $(DESTDIR)$(PREFIX)/bin/layouts.sh
	install -Dm755 mouse.sh $(DESTDIR)$(PREFIX)/bin/mouse.sh
	install -Dm755 move.sh $(DESTDIR)$(PREFIX)/bin/move.sh
	install -Dm755 position.sh $(DESTDIR)$(PREFIX)/bin/position.sh
	install -Dm755 runfyre.sh $(DESTDIR)$(PREFIX)/bin/runfyre.sh
	install -Dm755 setborder.sh $(DESTDIR)$(PREFIX)/bin/setborder.sh
	install -Dm755 size.sh $(DESTDIR)$(PREFIX)/bin/size.sh
	install -Dm755 snap.sh $(DESTDIR)$(PREFIX)/bin/snap.sh
	install -Dm755 wgroups.sh $(DESTDIR)$(PREFIX)/bin/wgroups.sh
	install -Dm755 wid.sh $(DESTDIR)$(PREFIX)/bin/wid.sh
	install -Dm755 windows.sh $(DESTDIR)$(PREFIX)/bin/windows.sh
	install -Dm755 winopen.sh $(DESTDIR)$(PREFIX)/bin/winopen.sh
	install -Dm755 yawee.sh $(DESTDIR)$(PREFIX)/bin/yawee.sh

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/blur.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/closest.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/focus.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/fullscreen.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/fyrerc.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/ignore.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/layouts.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/mouse.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/move.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/position.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/runfyre.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/setborder.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/size.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/snap.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/wgroups.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/wid.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/windows.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/winopen.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/yawee.sh
