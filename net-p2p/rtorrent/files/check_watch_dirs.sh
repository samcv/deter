#!/usr/bin/env bash

# check_watch_dirs.sh
# This script provides an ability to maintain a mirror of a part
#   of the filesystem tree for rtorrent, so that the downloaded files
#   could be placed separately from the .torrent files
#   and at the same time already in the place on the living filesystem
#   where they should be.
# check_watch_dirs.sh © deterenkelt, 2016


torrent_files_dir='/home/torrents'  # There  can be  several mirrors assembled
                                    # from different paths.  This ‘superglobal’
                                    # folder for all the mirrors
                                    # is torrent_files_dir.
storage_hosts=( home )  # Replace ‘home’ with your hostname  on which rtorrent
                        # is running  (this was introduced  for advanced setup
                        # that is not implemented yet).
storages=('/home' )  # The root directory  of the path where  the actual files
                     # are  to be  downloaded.  add '/another/path',  to clone
                     # its folders to the mirror.
                     # NB:  that  will   ONLY  CLONE  THE  EMPTY  FOLDER  TREE,
                     # it  won’t  download  files  to several  places  at once.
            # The idea of multilple sources  for the mirror tree (aka storages)
            # is to maintain the hierarchy from several storages, but download
            # only to one of them (you download, you watch, you decide, if you
            # store and where you store). The first storage path  mentioned is
            # the default  storage  for downloading.  Storages are supposed to
            # have more or less identical structure.
# Below are subfolders under paths in ‘storages’ which directory trees must be
# kept  in sync  with the mirror.  NOTE THAT ONLY THESE SUBFOLDERS AND THE SUB-
# FOLDERS  BELOW them will be watched by rtorrent for .torrent files!  No path
# specified in ‘storages’ is a directory for watch by itself! I.e. for what we
# have above, it would be /home/torrents/home. Don’t place files directly into
# this folder!
storage_subdirs=(         'brains' 'music'  'video' 'gamefiles' 'misc_torrents' 'picts/manga')
storage_subdirs_maxdepth=( 1        1        2       1           1               0)
watchdir_count=0  # a counter, that, for some unknown reason,  is required for
                  # the corresponding directove in rtorrent.rc.
verbose_log='_verbose'  # rtorrent’s verbosity per each rule?

# Remove any existing rules for watching directories from the config.
# W! THIS WILL ERASE THEM ALL!
sed -ri '/^\s*schedule\s*=\s*watch_directory.*/d' /home/$USER/.rtorrent.rc

for host in "${storage_hosts[@]}"; do
	[ "$host" = "${HOSTNAME%%.*}" ] && {
		[ -d "$torrent_files_dir/$host" ] &&
		[ -r "$torrent_files_dir/$host" ] &&
		[ -w "$torrent_files_dir/$host" ] &&
		[ -x "$torrent_files_dir/$host" ] ||
		mkdir --mode=775 "$torrent_files_dir/$host"
		chown -R --reference=/home/$USER/.rtorrent.rc "$torrent_files_dir/$host"
		# stashing all stuff
		cp -Ra "$torrent_files_dir/$host" "$torrent_files_dir/${host}.bak"
		# Cleaning the torrent_files_dir from folders deleted in the original storage.
		while IFS= read -r -d $'\0'; do
			REPLY=$(echo "$REPLY" | sed "s^$torrent_files_dir/$host/^^g")
			[ -e "${storages[0]}/$REPLY" ] || {
				einfo 'This directory wasn’t found in storage ↓'
				rm -rfv "$torrent_files_dir/$host/$REPLY"
			}
		done <  <(find "$torrent_files_dir/$host" -mindepth 1 -type d -print0)

		for ((i=0; i<${#storage_subdirs[@]}; i++)); do
			while IFS= read -r -d $'\0'; do
				REPLY=$(echo "$REPLY" | sed "s^${storages[0]}/^^g")
				[ -e "$torrent_files_dir/$host/$REPLY" ] ||
				mkdir -p --mode=775 "$torrent_files_dir/$host/$REPLY"
				for ((j=1; j<${#storages[@]}; j++)); do
					[ -e "${storages[$j]}/$REPLY" ] ||
					mkdir -p --mode=775 "${storages[$j]}/$REPLY"
				done
				REPLY=$(echo "$REPLY" | sed 's/ /\\\\\ /g; s/;/\\\\\;/g' )
				echo "schedule = watch_directory_$((watchdir_count++)),10,10,\"load_start$verbose_log=\\\"$torrent_files_dir/$host/$REPLY/*.torrent\\\",d.set_directory=\\\"${storages[0]}/$REPLY\\\"\"" >> /home/$USER/.rtorrent.rc
			done <  <(find "${storages[0]}/${storage_subdirs[$i]}" -maxdepth ${storage_subdirs_maxdepth[$i]} -type d -print0)
		done
		chown -R --reference=/home/$USER/.rtorrent.rc  "$torrent_files_dir"
		for storage in "${storages[@]}"; do
			for subfolder in "${storage_subdirs[@]}"; do
				unset old_subfolder
				until [ "$subfolder" = "$old_subfolder" ]; do
					chown -R --reference=/home/$USER/.rtorrent.rc "$storage/$subfolder"
					chmod -R ug+rwX "$storage/$subfolder"
					old_subfolder="$subfolder"
					subfolder="${subfolder%%/*}"
				done
			done
		done
	}
done
