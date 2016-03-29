fyre
====

fyre is set of scripts using standalone tools to form a complete X11
environment. As you run a specific script when you want to achieve a certain
window task, this means there is virtually no memory footprint for the
environment.

Installation
------------

#### Dependencies

fyre relies on the installation of:

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

#### Using the Makefile

You have two choices here:

- Symbolically link the scripts PREFIX/bin: `make link`
- Copy the scripts to PREFIX/bin: `make install`

I recommend the former as it'll allow you make modifications to the scripts
with the changes being applied immediately.

Usage
-----

Check out the [example sxhkd](https://raw.githubusercontent.com/wildefyr/fyre/master/sxhkdc.example) to see what you can do with fyre.

Start up your hotkey daemon of your choice in your xinitrc and append the
following at the end of your xinitrc:

```bash
exec runfyre
```

Example Desktops:
---------------

![The belly of the beast](https://wildefyr.net/media/screenshots/The%20belly%20of%20the%20beast.png)
![The Final Frontier](https://wildefyr.net/media/screenshots/thefinalfrontier.png)
![Blade Runner Blues](https://wildefyr.net/media/screenshots/bladerunnerblues.png)
![Endless](https://wildefyr.net/media/screenshots/clean.png)

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
