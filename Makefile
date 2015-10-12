PREFIX = /usr
MANPREFIX = $(PREFIX)/share/man

CC = cc
LD = $(CC)

CFLAGS += -std=c99 -pedantic -Wall -Os

SRC =			\
	xwait.c

OBJ = $(SRC:.c=.0)
BIN = $(SRC:.c=)

.POSIX:

all: binutils

.o:
	@echo "LD $@"

.c.o:
	@echo "CC $<"
	@$(CC) -c $< -o $@ $(CFLAGS)

install: $(BIN)
	mkdir -p $(DESTDIR)$(PREFIX)/bin/
	cp -f $(BIN) $(DESTDIR)$(PREFIX)/bin/

uninstall:
	@echo "uninstalling xwait"
	@for util in $(BIN); do \
		rm -f $(DESTDIR)$(PREFIX)/bin/$$util; \
	done
