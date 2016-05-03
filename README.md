# fyre

fyre is set of scripts using standalone tools to form a complete X11
environment. As you run a specific script when you want to achieve a certain
window task, this means there is virtually no memory footprint for the
environment.

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

- Symbolically link the scripts PREFIX/bin: `make link`
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
sxhkd](https://raw.githubusercontent.com/wildefyr/fyre/master/sxhkdc.example) to
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

![The belly of the beast](http://fyrious.ninja/media/screenshots/The%20belly%20of%20the%20beast.png)
![The Final Frontier](http://fyrious.ninja/media/screenshots/thefinalfrontier.png)
![Blade Runner Blues](http://fyrious.ninja/media/screenshots/bladerunnerblues.png)
![Endless](http://fyrious.ninja/media/screenshots/clean.png)

## Contributors

Contributors for specific scripts are listed in the files where they have
inputted ideas or code. Many thanks to the original wmutils authors: dcat &
z3bra

## Shameless Plug

If you want to contact me about anything, my website can be found
[here](https://fyrious.ninja) and I can also be found on the Freenode IRC under
the nick 'Wildefyr' where I am often found in #crux and #6c37. If you're feeling
particularly kind of heart, star this repository and/or follow me.
