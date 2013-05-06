require 'spec_helper'

describe 'logrotate' do

  let :facts do
    RSpec.configuration.default_facts.merge({
    })
  end
  
  it { should contain_class('logrotate::params') }

  it do
    should contain_package('logrotate').with({
      'ensure'  => 'present',
      'name'    => 'logrotate',
    })
  end

  it do
    should contain_file('/etc/logrotate.d').with({
      'ensure'  => 'directory',
      'path'    => '/etc/logrotate.d',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0755',
      'require' => 'Package[logrotate]'
    })
  end

  it do
    should contain_file('/etc/logrotate.conf').with({
      'ensure'  => 'present',
      'path'    => '/etc/logrotate.conf',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'require' => 'Package[logrotate]',
    })
  end

  it do
    should contain_file('/etc/logrotate.conf') \
      .with_content(/^weekly$/) \
      .with_content(/^rotate\s52$/) \
      .with_content(/^dateext$/) \
      .with_content(/^#compress$/) \
      .with_content(/^include\s\/etc\/logrotate.d$/)
  end

  it do
    should contain_file('/etc/logrotate.conf') \
      .with_content(/^\/var\/log\/wtmp\s+\{$/) \
      .with_content(/^\s+monthly$/) \
      .with_content(/^\s+rotate\s12$/) \
      .with_content(/^\s+minsize\s1M$/) \
      .with_content(/^\s+olddir\s\/var\/log\/archives\/wtmp$/) \
      .with_content(/^\s+create\s0664\sroot\sutmp$/) \
  end

  it do
    should contain_file('/etc/logrotate.conf') \
    .with_content(/^\/var\/log\/btmp\s+\{$/) \
    .with_content(/^\s+missingok$/) \
    .with_content(/^\s+monthly$/) \
    .with_content(/^\s+rotate\s12$/) \
    .with_content(/^\s+olddir\s\/var\/log\/archives\/btmp$/) \
    .with_content(/^\s+create\s0600\sroot\sutmp$/)
  end

  it do
    should contain_file('/etc/cron.daily/logrotate').with({
      'ensure'  => 'present',
      'path'    => '/etc/cron.daily/logrotate',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0755',
      'require' => 'Package[logrotate]',
    })
  end

  it do
    should contain_file('/var/log/archives').with({
      'ensure'  => 'directory',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0700',
      'require' => 'Package[logrotate]',
    })
  end

  it do
    should contain_file('/var/log/archives/wtmp').with({
      'ensure'  => 'directory',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0700',
      'require' => 'File[/var/log/archives]',
    })
  end

  it do
    should contain_file('/var/log/archives/btmp').with({
      'ensure'  => 'directory',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0700',
      'require' => 'File[/var/log/archives]',
    })
  end

  it do
    should contain_logrotate__file('yum').with({
      'log'			  => '/var/log/yum.log',
			'interval'	=> 'yearly',
			'size'		  => '30k',
			'rotation'	=> '4',
			'archive'		=> 'true',
			'create'		=> '0600 root root',
			'options'		=> [ 'missingok', 'notifempty', 'dateext' ],
    })
  end

  it do
    should contain_file('/etc/logrotate.d/yum').with({
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'require' => 'File[/etc/logrotate.d]',
    })
  end

  it do
    should contain_file('/etc/logrotate.d/yum') \
      .with_content(/^\/var\/log\/yum.log\s+\{$/) \
      .with_content(/^\s+missingok$/) \
      .with_content(/^\s+notifempty$/) \
      .with_content(/^\s+dateext$/) \
      .with_content(/^\s+yearly$/) \
      .with_content(/^\s+rotate\s4$/) \
      .with_content(/^\s+size\s30k$/) \
      .with_content(/^\s+olddir\s\/var\/log\/archives\/yum$/) \
      .with_content(/^\s+create\s0600\sroot\sroot$/) \
  end

  it do
    should contain_file('/var/log/archives/yum').with({
      'ensure'  => 'directory',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0700',
      'require' => 'File[/var/log/archives]',
    })
  end

  context 'when declaring archive => false' do
    let :params do
      { :archive => false }
    end

    it { should_not contain_file('/var/log/archive') }
    it { should_not contain_file('/var/log/archive/wtmp') }
    it { should_not contain_file('/var/log/archive/btmp') }
    it { should_not contain_file('/var/log/archive/yum') }

    it do
      should_not contain_file('/etc/logrotate.d/yum') \
        .with_content(/^\s+olddir\s\/var\/log\/archives\/yum$/)
    end
  end

  context 'when declaring rotation_interval => daily' do
    let :params do
      { :rotation_interval => 'daily' }
    end

    it { should contain_file('/etc/logrotate.conf').with_content(/^daily$/) }
    it { should_not contain_file('/etc/logrotate.conf').with_content(/^weekly$/) }
  end

  context 'when declaring rotate => 2' do
    let :params do
      { :rotate => '2' }
    end

    it { should contain_file('/etc/logrotate.conf').with_content(/^rotate\s2$/) }
    it { should_not contain_file('/etc/logrotate.conf').with_content(/^rotate\s52$/) }
  end

  context 'when declaring dateext => false and compress => true' do
    let :params do
      { :dateext => false, :compress => true }
    end

    it { should contain_file('/etc/logrotate.conf').with_content(/^compress$/) }
    it do
      should_not contain_file('/etc/logrotate.conf') \
        .with_content(/^dateext$/) \
        .with_content(/^#compress$/)
    end
  end

  context 'when declaring rotation_interval => foo' do
    let :params do
      { :rotation_interval => 'foo' }
    end

    it do
      expect { should contain_class('logrotate::params').to raise_error Puppet::Error, /does not match/ }
    end
  end

  context 'when declaring rotate => breakme' do
    let :params do
      { :rotation_interval => 'breakme' }
    end

    it do
      expect { should contain_class('logrotate::params').to raise_error Puppet::Error, /does not match/ }
    end
  end
end