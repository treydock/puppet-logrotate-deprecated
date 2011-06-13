define logrotate::file (
	$log=false,
	$interval=false,
	$rotation=false,
	$size=false,
	$options=false,
	$olddir=false,
	$create=false,
	$scripts=false,
	$postrotate=false
) {

	file { "/var/log/archives/${name}":
		ensure	=> 'directory',
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

	
