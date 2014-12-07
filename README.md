deter
=====
Gentoo overlay

### games-util/steam-launcher
It is the ebuild from gamerlay with

    || ( gnome-extra/zenity x11-terms/xterm )
    >=app-emulation/emul-linux-x86-baselibs-20121028

removed from dependecies, because I don’t need neither xterm (I use urxvt) nor zenity (it pulls gnome3 and was replaced with Xdialog in my scripts anyway). I can say that L4D2 works without any of these.

### gnome-extra/yad

YAD (yet another dialog) is a tool for creating graphical dialogs from shell scripts.

http://sourceforge.net/projects/yad-dialog/

### media-video/watchsh
[A wrapper for mpv/MPlayer to watch videos easy via CLI.](https://github.com/deterenkelt/watchsh)

### net-p2p/rtorrent
BitTorrent client using libtorrent.
This package uses `tmux` instead of `screen`, so you won’t need to keep the latter in your system anymore.
It doesn’t alter any of the rtorrent source code, only the init script.

Accessing the running rtorrent session can be done via this command:

    chmod o+rw `tty` \
        && sudo -u rtorrent -H tmux -u -S /home/rtorrent/.tmux/socket attach

Where `/home/rtorrent` is the home directory of the user running rtorrent.

For `urxvt` I’d recommend the following alias, that can also be found in the [dotfiles repository](https://github.com/deterenkelt/dotfiles/blob/master/bashrc/home.sh):

    alias rt="urxvtc -title rtorrent -hold \
                     -e /bin/bash -c 'chmod o+rw `tty` \
                        && sudo -u rtorrent -H tmux -u -S /home/rtorrent/.tmux/socket attach' &"

##### Separate storage for keeping files from .torrent and seeding ones
The _storage_ is where you keep the files organized. Now you can specify a folder that would mirror its directory tree, so the .torrent files could be placed separately, but their destination will be bound to the original tree, i.e. the storage. Mirroring can be restricted to specific folders with corresponding level of subdirectories inside them.

There can be more than one storage which directory trees would be mirrored to the directory for .torrent files. But only one to download the actual files. In case you have a big storage which you keep safe and away from the internet, and the other, maybe already faulty, that you use for seeding and don’t care if it will crash one day. Yes, seeding slowly kills your HDDs. So the scheme is simple: I download files to the old faulty storage, then, if I want to keep the files, I copy them to my big and safe storage.

If you’d want to use this, uncomment the `CHECK_WATCH_DIRS` variable in /etc/conf.d/rtorrentd. Example of [check_watch_dirs.sh](http://github.com/deterenkelt/deter/raw/master/net-p2p/rtorrent/files/check_watch_dirs.sh) can be found in `net-p2p/rtorrent/files/` (on your host), put it to the home directory of the user running rtorrent.

### How to include this overlay

    # layman -f
    # layman -a deter
