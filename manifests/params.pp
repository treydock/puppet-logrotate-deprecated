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

  case $::osfamily {
    'RedHat': {
      $log_dir                = '/var/log'
      $logrotate_archive_dir  = "${log_dir}/archives"
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }

}
