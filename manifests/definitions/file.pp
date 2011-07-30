define logrotate::file (
	$log=false,
	$interval=false,
	$rotation=false,
	$size=false,
	$minsize=false,
	$options=false,
	$archive=false,
	$olddir="${logrotate::params::logrotate_archive_dir}/${name}",
	$olddir_owner='root',
	$olddir_group='root',
	$olddir_mode='700',
	$create=false,
	$scripts=false,
	$postrotate=false
) {
	include logrotate::params

	file { "$olddir":
		ensure	=> 'directory',
		owner	=> $olddir_owner,
		group	=> $olddir_group,
		mode 	=> $olddir_mode,
		require	=> File["${logrotate::params::logrotate_archive_dir}"],
	}


	file { "/etc/logrotate.d/${name}":
		ensure	=> present,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '644',
		content	=> template('logrotate/logrotate_file.erb'),
		require	=> File['/etc/logrotate.d'],
	}

}

	
