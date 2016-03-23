Fyre
====

Fyre is set of scripts using standalone tools to form a more complete X11
environment. As you run a specific script when you want to achieve a certain
window task, this means there is virtually no memory footprint for the
environment other than what X11 requires.

Installation
------------

#### Manual Installation:

This repo relies on the installation of:

- [wmutils/core](https://github.com/wmutils/core)
- [wmutils/opt](https://github.com/wmutils/opt)
- xorg-xprop - Environment information.
- xorg-xinput - Enabling/Disabling input devices.

Personal recommendations for tools in your environment:

- dash - Massive speed increases over bash/zsh.
- [sxhkd](https://github.com/baskerville/sxhkd) - To bind scripts to hotkeys.
- [dmenu](http://tools.suckless.org/dmenu/) - Suckless menu for launching programs.
- [lemonbar](https://github.com/baskerville/bar) - An excellent statusbar program with clickable support.
- [hsetroot](https://github.com/elmiko/hsetroot) - Minimal background setter with clean options compared to feh.

I personally recommend system linking the scripts to somewhere on
your path, for example:

```bash
ln -s ./*.sh /usr/local/bin/
```

That way you can make changes to my original repository or maintain your own
fork with any changes you make being reflected immediately. Alternatively you
can use the Makefile I have provided to install the scripts.

Check out the [example sxhkd](https://raw.githubusercontent.com/wildefyr/fyre/master/sxhkdc.example) to see what you can do with fyre.

Finally, start up your hotkey daemon and put the following in your xinitrc:

```bash
exec runfyre.sh
```

Example scrots:
---------------

![The belly of the beast](https://raw.githubusercontent.com/wildefyr/dotfiles/master/screenshots/The%20belly%20of%20the%20beast.png)
![Cityscape](https://raw.githubusercontent.com/wildefyr/dotfiles/master/screenshots/cityscape.png)
![The Final Frontier](https://raw.githubusercontent.com/wildefyr/dotfiles/master/screenshots/thefinalfrontier.png)
![Blade Runner Blues](https://raw.githubusercontent.com/wildefyr/dotfiles/master/screenshots/bladerunnerblues.png)
![Endless](https://github.com/wildefyr/dotfiles/blob/master/screenshots/clean.png?raw=true)

Contributors
------------

Contributors for specific scripts are listed in the files where they have
inputted ideas or code. Many thanks to the original wmutils authors:
dcat & z3bra.

Shameless Plug
--------------

If you want to contact me about anything, my website can be found
[here](https://wildefyr.net) and I can also be found on the Freenode IRC under
the nick 'Wildefyr' where I am often found in #crux and #6c37. If you're
feeling particularly kind of heart, star this repository and/or follow me.
