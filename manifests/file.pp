# == Define: logrotate::file
#
# Defines a logrotation schedule for a log file.
#
# === Parameters
#
# Full documentation of each parameter's meaning
# can be found at http://linux.die.net/man/8/logrotate .
#
# [*log*]
#
# [*interval*]
#
# [*rotation*]
#
# [*size*]
#
# [*minsize*]
#
# [*options*]
#
# [*archive*]
#
# [*olddir*]
#
# [*olddir_owner*]
#
# [*olddir_group*]
#
# [*olddir_mode*]
#
# [*create*]
#
# [*postrotate*]
#
# === Examples
#
#   logrotate::file { 'foo':
#     log => '/var/log/foo.log',
#   }
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
define logrotate::file (
  $log          = 'UNSET',
  $interval     = false,
  $rotation     = false,
  $size         = false,
  $minsize      = false,
  $options      = false,
  $archive      = false,
  $olddir       = 'UNSET',
  $olddir_owner = 'UNSET',
  $olddir_group = 'UNSET',
  $olddir_mode  = 'UNSET',
  $create       = false,
  $postrotate   = false
) {
  include logrotate
  
  $archive_dir = $logrotate::archive_dir
  
  $log_real = $log ? {
    'UNSET'   => "/var/log/${name}.log",
    default   => $log,
  }
  $interval_real = $interval ? {
    'UNSET'   => false,
    default   => $interval,
  }
  $olddir_real = $olddir ? {
    'UNSET'   => "${archive_dir}/${name}",
    default   => $olddir,
  }
  $olddir_owner_real = $olddir_owner ? {
    'UNSET'   => 'root',
    default   => $olddir_owner,
  }
  $olddir_group_real = $olddir_group ? {
    'UNSET'   => 'root',
    default   => $olddir_group,
  }
  $olddir_mode_real = $olddir_mode ? {
    'UNSET'   => '0700',
    default   => $olddir_mode,
  }

  if $archive {
    file { $olddir_real:
      ensure  => 'directory',
      owner   => $olddir_owner_real,
      group   => $olddir_group_real,
      mode    => $olddir_mode_real,
      require => File[$archive_dir],
    }
  }

  file { "/etc/logrotate.d/${name}":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('logrotate/logrotate_file.erb'),
    require => File['/etc/logrotate.d'],
  }

}


