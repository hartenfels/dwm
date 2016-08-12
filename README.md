# This is my dwm

There are many like it, but this one is mine. It's got:

* systray

Just a sweet patch from <http://dwm.suckless.org/patches/systray>.

* workspace emulation

Pretend that your tags are workspaces like you're some pleb using Unity or
something. `Ctrl-Alt-Up/Down` shows the previous/next workspace.
`Ctrl-Alt-Left/Right` moves the current window too. If you have multiple tags
selected, the first one counts as your workspace.


## Requirements

* Xlib

* libXinerama, for multi-monitors


## Installation

`make` to build from source.

`sudo make install` to put the executable in `/usr/local/bin`.

Put `exec dwm` at the end of `~/.xinitrc` so that X will use it.
