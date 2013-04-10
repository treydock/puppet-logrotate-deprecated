# == Class: logrotate
#
# Manage the logrotate installation and configuration.
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
class logrotate {
  include logrotate::base
}
