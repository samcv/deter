#!/usr/bin/env bash
torrent_files_dir='/home/torrents'
# ‘Host’ supposed to identify a folder under /home/torrents/
storage_hosts=( home )
# Where actual files to be downloaded
storages=('/home' ) #'/old_home'
storage_for_download=0
# Subfolders under storage_main_dir which directory trees must be kept in sync
storage_subdirs=(         'brains' 'music'  'video' 'gamefiles' 'misc_torrents' 'picts/manga')
storage_subdirs_maxdepth=(1        1        2         1           1                0)
watchdir_count=0
verbose_log='_verbose' # rtorrent verbosity per each rule(?)

# Remove any existing rules for watching directories from the config.
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
				echo "schedule = watch_directory_$((watchdir_count++)),10,10,\"load_start$verbose_log=\\\"$torrent_files_dir/$host/$REPLY/*.torrent\\\",d.set_directory=\\\"${storages[$storage_for_download]}/$REPLY\\\"\"" >> /home/$USER/.rtorrent.rc
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
