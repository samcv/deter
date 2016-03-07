deter
=====
Gentoo overlay

### gnome-extra/yad

YAD (yet another dialog) is a tool for creating graphical dialogs from shell scripts.

http://sourceforge.net/projects/yad-dialog/

### media-video/watchsh
[A wrapper for mpv/MPlayer to watch videos easy via CLI.](https://github.com/deterenkelt/watchsh)

### net-p2p/rtorrent
BitTorrent client using libtorrent.
In this overlay the ebuild file for `rtorrent` is modified to use `tmux` instead of `screen`, so you don’t need to keep the latter in your system anymore. The init.d script is modified accordingly to run a `tmux` session at startup. Before the start, if the variable `CHECK_WATCH_DIRS` is set and contains a name of an executable file residing in the home directory of the user running `rtorrentd`, it runs that file. The variable, if needed, should be set in `/etc/conf.d/rtorrentd`, as usual. An example file `check_watch_dirs.sh` comes with the ebuild and can be found in layman with the following command.

    $ ls /var/lib/layman/deter/net-p2p/rtorrent/files/check_watch_dirs.sh

This script maintains a mirrored folder tree of your filesystem for you, so you could keep .torrent files separately from the files you download and get what you download already placed where it needs to be. `check_watch_dirs.sh` modifies `rtorrent.rc`, so the rtorrent daemon will check for .torrent files in the mirror and use corresponding path **on the living filesystem** to download the torrent itself.

![](https://raw.githubusercontent.com/wiki/deterenkelt/deter/images/rtorrentd-mirroring.gif)

Variables that you need to set in [check_watch_dirs.sh](https://github.com/deterenkelt/deter/blob/master/net-p2p/rtorrent/files/check_watch_dirs.sh) are commented well and should be self-explanatory.

For easy access to the rtorrent running in tmux use an alias.

    alias rt="urxvtc -title rtorrent -hold \
                     -e /bin/bash -c 'chmod o+rw `tty` \
                                        && sudo -u rtorrent -H tmux -u -S /home/rtorrent/.tmux/socket attach' &"

Here it calls an `urxvt` terminal and passes to it a command which runs `tmux attach`. It supposes that the daemon is running from another user for security measures. In this case you may also need to allow the user you usually log in as to run this command without a password. The needed part for your `/etc/sudoers` is below.

    User_Alias RTORRENT_USER = my_user_name
    Cmnd_Alias RTORRENT_CMD  = /usr/bin/tmux, \
                               /usr/bin/pkill -STOP -xf /usr/bin/rtorrent, \
                               /usr/bin/pkill -CONT -xf /usr/bin/rtorrent
    Defaults:RTORRENT_USER env_reset
    Defaults:RTORRENT_USER env_keep += DISPLAY
    Defaults:RTORRENT_USER env_keep += XAUTHORITY
    RTORRENT_USER ALL = (rtorrent) NOPASSWD: RTORRENT_CMD

Where `my_user_name` is the name of the user that will be actually using rtorrent in tmux, and `rtorrent` is the name of the user that starts the daemon. Usually it’s name is set in `/etc/conf.d/rtorrentd`.

The additional commands that send `SIGSTOP` and `SIGCONT` are not necessary, but come in handy, if you need to temporary set `rtorrent` on pause to free the link. You can find the functions `rt-pause` and `rt-unpause` in my [home.sh](https://github.com/deterenkelt/dotfiles/blob/master/bashrc/home.sh) under the `rt` alias.

### x11-themes/shiki-colors
Seven elegant themes for Murrine GTK+2 Cairo engine.

This ebuild doesn’t depend on any WMs, unlike his brothers in another repositories, it requires only `x11-themes/gtk-engines-murrine`. This is funny, but for some reason, all the other ebuilds known to me at this time pull `x11-themes/gtk-engines`, which actually doesn’t contain the Murrine Cairo engine, which goes with a separate package.

### How to include this overlay

    # layman -f
    # layman -a deter
