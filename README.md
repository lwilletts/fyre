Fyre
====

Appearance:
-----------

![Example Desktop](https://github.com/Wildefyr/wildconfig/blob/master/screenshots/fyre2015-08-27.png)
> #### [Workflow]()

Installation
------------

You can install fyre with very little fuss by using these methods:

- [Crux Port](https://github.com/wildefyr/wild-crux-ports)
- [Archlinux Aur]()

#### Manual Installation:

This repo relies on the installation of
[wmutils/core](https://github.com/wmutils/core) and
[wmutils/opt](https://github.com/wmutils/opt). I also have my own fork of
[wmutils/opt](https://github.com/wildefyr/opt) which allows the use of middle
mouse click to focus a window.

To install, make xwait.c, and then add the directory to your path or move the
executables a directory in your shells path.

Some optional dependancies that you might find interesting:

- mksh - The fastest shell I've tried and I recommend you install this so
  detection.sh/tile.sh feel very responsive. All bangs are also #!/bin/mksh by
  default.
- xorg-xinput
- transset-df

#### Other considerations:

As with things of this type, there are many optional components, for example:

- dmenu
- compton
- lemonbar
- hsetroot

You'll have to install these separately depending on your distribution, but
most of them can be grabbed from source (In dmenu's case, you apply the patches
you need). Configuration for these can be found in my
[dotfiles](https://github.com/Wildefyr/wildconfig) and
[script](https://github.com/Wildefyr/scripts) repositories.

Known Issues
------------

No piece of software is perfect:

- Having two instances of mpv causes the second one to be treated as a urxvtc
  window, becoming tiled.
- The 'detection' script is too slow and could do with being modularised.
- Middle mouse is glitchy on touchpads, especially if using my fork of opt.

Shameless Plug
--------------

If you want to contact me about anything, my website can be found
[here](http://wildefyr.net) and I can also be found on the Freenode IRC under
the nick 'Wildefyr' where I am often found in #crux and #6c37.
