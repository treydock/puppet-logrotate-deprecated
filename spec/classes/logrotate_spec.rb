require 'spec_helper'

describe 'logrotate' do

  let(:facts) {
    {
      :osfamily => 'RedHat',
    }
  }


  it { should contain_class('logrotate::base') }

  context 'logrotate::base' do
    it do
      should contain_package('logrotate').with({
        'ensure'  => 'installed',
      })
    end

    it do
      should contain_file('/etc/logrotate.d').with({
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'require' => 'Package[logrotate]'
      })
    end

    it do
      should contain_file('/etc/logrotate.conf').with({
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => 'Package[logrotate]',
      })
    end

    it do
      should contain_file('/etc/cron.daily/logrotate').with({
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'require' => 'Package[logrotate]',
        'notify'  => 'Service[crond]',
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
        .with_content(/^\/var\/log\/yum.log\s+{$/) \
        .with_content(/^\s+missingok$/) \
        .with_content(/^\s+notifempty$/) \
        .with_content(/^\s+dateext$/) \
        .with_content(/^\s+yearly$/) \
        .with_content(/^\s+rotate\s4$/) \
        .with_content(/^\s+size\s30k$/) \
        .with_content(/^\s+olddir\s\/var\/log\/archives\/yum$/) \
        .with_content(/^\s+create\s0600\sroot\sroot$/) \
    end
  end
end