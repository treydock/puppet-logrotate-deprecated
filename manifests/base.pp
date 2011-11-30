class logrotate::base {
	include logrotate::params

	package { 'logrotate':
		ensure	=> installed,
	}

	file { '/etc/logrotate.d':
		ensure	=> directory,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '755',
		require	=> Package['logrotate'],
	}

	file { '/etc/logrotate.conf':
		ensure	=> present,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '644',
		source	=> 'puppet:///modules/logrotate/logrotate.conf',
		require	=> Package['logrotate'],
	}

	file { '/etc/cron.daily/logrotate':
		ensure	=> present,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '755',
		source	=> 'puppet:///modules/logrotate/logrotate_cron',
		require	=> Package['logrotate'],
		notify	=> Service['crond'],
	}

	file { "${logrotate::params::logrotate_archive_dir}":
		ensure	=> directory,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '700',
		require	=> Package['logrotate'],
	}


	file { "${logrotate::params::logrotate_archive_dir}/wtmp":
		ensure	=> directory,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '700',
		require	=> File["${logrotate::params::logrotate_archive_dir}"],
	}

	file { "${logrotate::params::logrotate_archive_dir}/btmp":
		ensure	=> directory,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '700',
		require	=> File["${logrotate::params::logrotate_archive_dir}"],
	}

	if $operatingsystem == "CentOS" {
		logrotate::file { 'yum':
			log			=> '/var/log/yum.log',
			interval	=> 'yearly',
			size		=> '30k',
			rotation	=> '4',
			archive		=> 'true',
			create		=> '0600 root root',
			options		=> [ 'missingok', 'notifempty', 'dateext' ],
		}
	}
}
