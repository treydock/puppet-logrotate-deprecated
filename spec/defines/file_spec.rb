require 'spec_helper'

describe 'logrotate::file' do

  let :facts do
    RSpec.configuration.default_facts.merge({
    })
  end

  let(:title) { 'foo' }

  it { should contain_class('logrotate') }

  it { should_not contain_file('/var/log/archives/foo') }

  it do
    should contain_file('/etc/logrotate.d/foo').with({
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'require' => 'File[/etc/logrotate.d]',
    })
  end

  it do
    should contain_file('/etc/logrotate.d/foo') \
      .with_content(/^\/var\/log\/#{title}.log\s+\{$/)
  end
  
  context 'postrotate as a string' do
    let(:params) {
      {
        :postrotate => 'foobar',
      }
    }

    it do
      should contain_file('/etc/logrotate.d/foo') \
        .with_content(/^\/var\/log\/#{title}.log\s+\{$/) \
        .with_content(/^\s+postrotate$/) \
        .with_content(/^\s+#{params[:postrotate]}$/) \
        .with_content(/^\s+endscript$/)
    end
  end

  context 'postrotate as an array' do
    let(:params) {
      {
        :postrotate => [ 'foo', 'bar' ],
      }
    }

    it do
      should contain_file('/etc/logrotate.d/foo') \
        .with_content(/^\/var\/log\/#{title}.log\s+\{$/) \
        .with_content(/^\s+postrotate$/) \
        .with_content(/^\s+foo$/) \
        .with_content(/^\s+bar$/) \
        .with_content(/^\s+endscript$/)
    end
  end
  
  context 'full example as listed in README' do
    let(:title) { 'syslog' }
    let(:params) {
      {
        :log        => '/var/log/messages /var/log/secure /var/log/maillog /var/log/boot.log /var/log/cron',
        :interval   => 'weekly',
        :rotation   => '52',
        :size       => '1M',
        :archive    => true,
        :options    => [ 'missingok', 'sharedscripts' ],
        :postrotate => '/bin/kill -HUP `cat /var/run/rsyslogd.pid 2> /dev/null` 2> /dev/null || true',
      }
    }
    
    it do
      should contain_file('/var/log/archives/syslog').with({
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0700',
        'require' => 'File[/var/log/archives]'
      })
    end
    
    it do
      should contain_file("/etc/logrotate.d/#{title}") \
        .with_content(/^#{params[:log]}\s\{$/) \
        .with_content(/^\s+missingok$/) \
        .with_content(/^\s+sharedscripts$/) \
        .with_content(/^\s+#{params[:interval]}$/) \
        .with_content(/^\s+rotate\s#{params[:rotation]}$/) \
        .with_content(/^\s+size\s#{params[:size]}$/) \
        .with_content(/^\s+olddir\s\/var\/log\/archives\/syslog$/) \
        .with_content(/^\s+postrotate$/) \
        .with_content(/^\s+#{params[:postrotate]}$/) \
        .with_content(/^\s+endscript$/)
    end
  end
end
