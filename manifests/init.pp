# == Class: logrotate
#
# Manage the logrotate installation and configuration.
#
# === Parameters
#
# [*rotation_interval*]
#   The rotation interval.
#   Valid values: daily, weekly, monthly, yearly
#   Default: weekly
#
# [*rotate*]
#   Integer that sets the number of times a
#   file is rotated before being removed.
#   Default: 52
#
# [*dateext*]
#   This boolean sets the rotated files extension
#   to use date format rather than number.
#   Default: true
#
# [*compress*]
#   This boolean value enables compression
#   of rotated files.
#   Default: false
#
# [*package_name*]
#   Operatingsystem specific logrotate package name.
#
# [*confd_path*]
#   Operatingsystem specific location of logrotate.d
#
# [*conf_path*]
#   Operatingsystem specific path to logrotate.conf
#
# [*cron_daily_path*]
#   Operatingsystem specific locate of cron.daily
#   to activate logrotate
#
# [*archive*]
#   A value of false disables the default archiving.
#   Default: true
#
# [*archive_dir*]
#   Path for moving rotated log files.
#   Default: /var/log/archive
#
# === Examples
#
#  class { logrotate: }
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class logrotate (
  $rotation_interval  = 'weekly',
  $rotate             = '52',
  $dateext            = true,
  $compress           = false,
  $package_name       = $logrotate::params::package_name,
  $confd_path         = $logrotate::params::confd_path,
  $conf_path          = $logrotate::params::conf_path,
  $cron_daily_path    = $logrotate::params::cron_daily_path,
  $archive            = true,
  $archive_dir        = $logrotate::params::archive_dir

) inherits logrotate::params {

  validate_re($rotation_interval, '(daily|weekly|monthly|yearly)')
  validate_re($rotate, '[0-9]+')

  package { 'logrotate':
    ensure  => present,
    name    => $package_name,
  }

  file { '/etc/logrotate.d':
    ensure  => directory,
    path    => $confd_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['logrotate'],
  }

  file { '/etc/logrotate.conf':
    ensure  => present,
    path    => $conf_path,
    content => template('logrotate/logrotate.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['logrotate'],
  }

  file { '/etc/cron.daily/logrotate':
    ensure  => present,
    path    => $cron_daily_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('logrotate/logrotate.crondaily.erb'),
    require => Package['logrotate'],
  }

  if $archive {
    file { $archive_dir:
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      require => Package['logrotate'],
    }

    file { "${archive_dir}/wtmp":
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      require => File[$archive_dir],
    }

    file { "${archive_dir}/btmp":
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      require => File[$archive_dir],
    }
  }

  if $::osfamily == 'Redhat' {
    logrotate::file { 'yum':
      log       => '/var/log/yum.log',
      interval  => 'yearly',
      size      => '30k',
      rotation  => '4',
      archive   => $archive,
      create    => '0600 root root',
      options   => [ 'missingok', 'notifempty', 'dateext' ],
    }
  }
}
