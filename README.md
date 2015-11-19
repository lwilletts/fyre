Fyre
====

Appearance:
-----------

![Example Desktop](https://github.com/Wildefyr/wildconfig/blob/master/screenshots/clean.png)

Installation
------------

You can install fyre with very little fuss by using these methods:

- [Crux Port](https://github.com/wildefyr/wild-crux-ports)
- Archlinux Aur - Coming soon!

#### Manual Installation:

This repo relies on the installation of
[wmutils/core](https://github.com/wmutils/core) and
[wmutils/opt](https://github.com/wmutils/opt). I also have my own fork of
[wmutils/opt](https://github.com/wildefyr/opt) which allows the use of middle
mouse click to focus a window.

To install, compile xwait.c, and then add the directory to your path or move the
executables a directory in your shells path. The config file is read from
~/.config/fyre/fyrerc. I've included an example fyrerc in the repository.
Without setting at least some of the things even the basic scripts require
(i.e. focus.sh), these scripts will not work.

Some optional dependancies that you might find interesting:

- mksh - The fastest shell I've tried and I recommend you install this so
  winopen.sh/tile.sh feel very responsive.
- xorg-xprop
- xorg-xinput
- transset-df

#### Other considerations:

With minimal setups of this kind, you'll need/want programs that fulfil other
desires, such as:

- dmenu
- compton
- lemonbar
- hsetroot

You'll have to install these separately depending on your distribution, but
all of them can be grabbed from source. My personal configuration for these
can be found in my [dotfiles](https://github.com/wildefyr/wildconfig) and
[script](https://github.com/wildefyr/scripts) repositories.

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
