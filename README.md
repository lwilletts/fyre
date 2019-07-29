# fyre is now no longer being worked on

I have moved to a cwm based setup using striped down versions of these scripts
that can be found [here](https://github.com/lwilletts/fwm). The main reason for
switching is that cwm provides far better mouse support with context menus when
clicking on the root window; better sloppy focus support than just using wew;
selection of windows by typing a string using `menu-window` and of course: no
unnecessary fluff added.

This repo will stay up as it still provides valuable code samples for those
wishing to build their own wmutils environment.

## fyre

fyre is set of scripts using standalone tools to form a complete X11
environment. As you run a specific script when you want to achieve a certain
window task, this means there is virtually no memory footprint for the
environment.

```
15:50     %fyr | wmutils is love
15:50     %fyr | wmutils is lyfe
15:50    @rocx | wmutils is fyre
```

## Installation

#### Dependencies

fyre relies on the installation of:

- [wmutils/core](https://github.com/wmutils/core)
- [wmutils/opt](https://github.com/wmutils/opt)
- xorg-xprop - Environment information.

#### Optional

- [killwa](https://github.com/wmutils/contrib/tree/master/killwa) - Drop-in replacement for `killw`.
- xorg-xinput - Enabling/Disabling input devices. (see [mouse](https://github.com/wildefyr/fyre/blob/master/mouse))

Personal recommendations for tools in your environment:

- dash - Massive speed increases over bash/zsh.
- [sxhkd](https://github.com/baskerville/sxhkd) - To bind scripts to hotkeys.
- [dmenu](http://tools.suckless.org/dmenu/) - Suckless menu for launching programs.
- [lemonbar](https://github.com/baskerville/bar) - An excellent statusbar program with clickable support.
- [hsetroot](https://github.com/elmiko/hsetroot) - Minimal background setter with clean options compared to feh.

#### Using the Makefile

You have two choices here:

- Symbolically link the scripts to PREFIX/bin: `make link`
- Copy the scripts to PREFIX/bin: `make install`

I recommend the former as it'll allow you make modifications to the scripts
with the changes being applied immediately.

#### Configuration

fyre will look for a configuration file located at `$CONFIGDIR/config`, see
config.example for an idea of can be set. You can copy the default
config.example to the correct location using `make config`.

fyre also places files that are used only when the X11 session is active in
/tmp, the reason being that if /tmp is mounted as a tmpfs (a kind of RAM disk),
access to these files should theoretically be faster.

## Usage

Check out the [example
sxhkd](https://raw.githubusercontent.com/wildefyr/fyre/master/extras/sxhkdc.example) to
see what you can do with fyre.

Start up your hotkey daemon of your choice in your xinitrc and append the
following at the end of your xinitrc:

```bash
exec runfyre
```

#### Extras

Minor things in here that you may be interested in:

- Examples of sxhkd and fyre configuration files.
- Source fyre variables and general functions into zsh safely.
- Example lemonbar-specific output to show and control current groups.
- The standalone version of `windows` that supports contrib's `focus.sh`

## Example Desktops:

![The Belly of the Beast](/extras/desktops/thebellyofthebeast.png)
![The Final Frontier](/extras/desktops/thefinalfrontier.png)
![Blade Runner Blues](/extras/desktops/bladerunnerblues.png)

## Contributors

Contributors for specific scripts are listed in the files where they have
inputted ideas or code. Many thanks to the original wmutils authors: dcat &
z3bra
