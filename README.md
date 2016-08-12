# This is my dwm

There are many like it, but this one is mine. It's got:

* systray

Just a sweet patch from <http://dwm.suckless.org/patches/systray>.

* workspace emulation

Pretend that your tags are workspaces like you're some pleb using Unity or
something. `Ctrl-Alt-Up/Down` shows the previous/next workspace.
`Ctrl-Alt-Left/Right` moves the current window too.

Layouts and the stack factor or whatever you call it are remembered for every
workspace.

If you have multiple tags selected, the first one counts as your workspace.

* window count

Instead of showing fixed tags in the top bar, the current number of windows in
that tag is shown instead. I find it useful to find where my windows are at,
rather than having to scroll through every tag of every monitor looking for it.


## Requirements

* Xlib

* libXinerama, for multi-monitors


## Installation

`make` to build from source.

`sudo make install` to put the executable in `/usr/local/bin`.

Put `exec dwm` at the end of `~/.xinitrc` so that X will use it.
