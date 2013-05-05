# puppet-logrotate [![Build Status](https://travis-ci.org/treydock/puppet-logrotate.png)](https://travis-ci.org/treydock/puppet-logrotate)

## Installation

Place this in your Puppet installation's module directory

Requires puppet-cron , OR , the cron package must be defined else where before calling logrotate

## Usage

1. Add logrotate class to node

```
include logrotate
```

### Adding logrotate files

In your node defintion include something similiar to the following before "include logrotate"

```
    logrotate::file { "syslog" :
        log         => '/var/log/messages /var/log/secure /var/log/maillog /var/log/boot.log /var/log/cron',
        interval    => 'weekly',
        rotation    => '52',
        size        => '1M',
        archive     => 'true',
        options     => [ 'missingok', 'sharedscripts' ],
        postrotate  => '/bin/kill -HUP `cat /var/run/rsyslogd.pid 2> /dev/null` 2> /dev/null || true',
    }   
```

## Development

### Dependencies

* Ruby 1.8.7
* Bundler

### Running rspec-puppet tests

1. To install dependencies run `bundle install`
2. Run tests using `rake spec:all`
