define logrotate::file (
	$log=false,
	$interval=false,
	$rotation=false,
	$size=false,
	$options=false,
	$archive=false,
	$create=false,
	$scripts=false,
	$postrotate=false
) {
	include logrotate::params

	file { "${logrotate::params::logrotate_archive_dir}/${name}":
		ensure	=> 'directory',
		owner	=> 'root',
		group	=> 'root',
		mode 	=> '700',
		require	=> File["${logrotate::params::logrotate_archive_dir}"],
	}


	file { "/etc/logrotate.d/${name}":
		ensure	=> present,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '644',
		content	=> template('logrotate/logrotate_file.erb'),
		require	=> [ File['/etc/logrotate.d'], File["${logrotate::params::logrotate_archive_dir}/${name}"] ],
	}

}

	
