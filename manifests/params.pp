# Class: logrotate::params
#
#   The logrotate configuration settings.
#   Do not include this class.
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class logrotate::params {
  
  $archive_dir = $::logrotate_archive_dir ? {
    undef   => '/var/log/archives',
    default => $::logrotate_archive_dir,
  }

  case $::osfamily {
    'RedHat': {
      $package_name           = 'logrotate'
      $log_dir                = '/var/log'
      $logrotate_archive_dir  = "${log_dir}/archives"
      $conf_path              = '/etc/logrotate.conf'
      $confd_path             = '/etc/logrotate.d'
      $cron_daily_path        = '/etc/cron.daily/logrotate'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }

}
