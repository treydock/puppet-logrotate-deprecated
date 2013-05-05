# Class: logrotate::params
#
#   The logrotate configuration settings.
#   Do not include this class.
#
# === Variables
#
# [*logrotate_archive_dir*]
#   Top-scope or ENC value that sets the archive directory path.
#   Default: /var/log/archives
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

  case $::osfamily {
    'RedHat': {
      $package_name           = 'logrotate'
      $log_dir                = '/var/log'
      $conf_path              = '/etc/logrotate.conf'
      $confd_path             = '/etc/logrotate.d'
      $cron_daily_path        = '/etc/cron.daily/logrotate'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }

  $archive_dir = $::logrotate_archive_dir ? {
    undef   => "${log_dir}/archives",
    default => $::logrotate_archive_dir,
  }

}
