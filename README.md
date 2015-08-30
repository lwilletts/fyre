Fyre
====

Appearance:
-----------

#### Example Desktop
![Example Desktop](https://github.com/Wildefyr/wildconfig/blob/master/screenshots/fyre2015-08-27.png)
#### [Workflow]()

Installation
------------

This repo relies on the installation of [wmutils
core](https://github.com/wmutils/core) and [wmutils
opt](https://github.com/wmutils/opt). You must then compile xwait.c using c
compiler or execute xwait.c using tcc. Have a look at xinitrc.example for what
you need for when loading Xorg.

To execute the scripts, you'll need them somewhere on your path, you can either
move it to a directory that is already in the path, or you can add the git repo
to your path. See your shell's documentation on how to do this.

As with things of this type, there are many optional components, for example:

- Feh (Background Setting)
- Dmenu
- Compton
- Lemonbar

You'll have to install these separately depending on your distribution, but
most of them can be grabbed from source (In dmenu's case, you apply the patches
you need). Configuration for these can be found in my
[dotfiles](https://github.com/Wildefyr/wildconfig) and
[script](https://github.com/Wildefyr/scripts) repositories.

Known Issues
------------

No piece of software is perfect:

- Closing a program via it's inbuilt means (I.e. <C-d> in your terminal
emulator) while in fullscreen mode, means that temp files are left undeleted.
Run 'fullscreen' once to delete the temporary files and again to place a new
window in fullscreen.
- Having two instances of mpv causes the second one to be treated as a urxvtc
window, becoming tiled.

Shameless Plug
--------------

If you want to contact me about anything, my website can be found
[here](http://wildefyr.net) and I can also be found on the Freenode IRC under
the nick 'Wildefyr' where I am often found in #archlinux and #neovim.
