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
# [*scripts*]
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
  $log          = false,
  $interval     = false,
  $rotation     = false,
  $size         = false,
  $minsize      = false,
  $options      = false,
  $archive      = false,
  $olddir       = 'UNSET',
  $olddir_owner = 'root',
  $olddir_group = 'root',
  $olddir_mode  = '0700',
  $create       = false,
  $scripts      = false,
  $postrotate   = false
) {
  include logrotate::params

  $olddir_real = $olddir ? {
    'UNSET'   => "${logrotate::params::logrotate_archive_dir}/${name}",
    default   => $olddir,
  }

  file { $olddir_real:
    ensure  => 'directory',
    owner   => $olddir_owner,
    group   => $olddir_group,
    mode    => $olddir_mode,
    require => File[$logrotate::params::logrotate_archive_dir],
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


