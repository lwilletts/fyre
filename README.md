Fyre
====

Strict POSIX compliant shell scripts using wmutils to form one lightweight and
minimal X window environment.

Appearance:
-----------

![Example Desktop](https://github.com/Wildefyr/wildconfig/blob/master/screenshots/clean.png)

Installation
------------

You can install fyre with very little fuss by using these methods:

- [Crux Port](https://github.com/wildefyr/wild-crux-ports)
- Archlinux Aur - Coming soon!

#### Manual Installation:

This repo relies on the installation of:

- [wmutils/libwm](https://github.com/wmutils/libwm)
- [wmutils/core](https://github.com/wmutils/core)
- [wmutils/opt](https://github.com/wmutils/opt)

I also have my own fork of [wmutils/opt](https://github.com/wildefyr/opt)
which allows the use of middle mouse click to focus a window.

There are two scripts I've kept separate from the main bunch so that you can
copy them and modify them to your needs, they are:

- fyrerc - The global variable source file which controls the many 'basic'
  settings of fyre.
- winopen - A script that takes window id's and decides what to do with them.

Some optional dependancies that you might find interesting:

- dash - The fastest shell POSIX compliant shell ever, syslink it to /bin/sh
  instead of bash and watch everything work better.
- xorg-xprop - To grab information about the environment to manipulate it.
- xorg-xinput - Controlling input devices.
- hsetroot - Minimal background setter with clean options compared to feh.
- dmenu - suckless menu for launching programs.
- lemonbar - Excellent statusbar program with clickable support.
- compton - Best X compositing manager out there.
- transset-df - Manipulate window transparency interactively.

You'll have to install these separately depending on your distribution, but
all of them can be grabbed from source. My personal configuration for these
can be found in my [dotfiles](https://github.com/wildefyr/wildconfig) and
[bin](https://github.com/wildefyr/bin) repositories.

Authors
-------

Authors for specific scripts are listed in the files where they have
contributed ideas or code. Many thanks to the original wmutils authors:
dcat & z3bra.

Shameless Plug
--------------

If you want to contact me about anything, my website can be found
[here](http://wildefyr.net) and I can also be found on the Freenode IRC under
the nick 'Wildefyr' where I am often found in #crux and #6c37.
