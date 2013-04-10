require 'spec_helper'

describe 'logrotate::file' do

  let(:facts) {
    {
      :osfamily => 'RedHat',
    }
  }

  let(:title) { 'foo' }

  let(:params) {
    {
      :log => '/var/log/foo.log',
    }
  }


  it { should contain_class('logrotate::params') }

  it do
    should contain_file('/var/log/archives/foo').with({
      'ensure'  => 'directory',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0700',
      'require' => 'File[/var/log/archives]'
    })
  end


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
      .with_content(/^\/var\/log\/foo.log\s+{$/)
  end

  context 'postrotate as an array' do
    let(:params) {
      {
        :log        => '/var/log/foo.log',
        :postrotate => [ 'foo', 'bar' ],
      }
    }

      it do
        should contain_file('/etc/logrotate.d/foo') \
          .with_content(/^\/var\/log\/foo.log\s+{$/) \
          .with_content(/^\s+postrotate$/) \
          .with_content(/^\s+foo$/) \
          .with_content(/^\s+bar$/) \
          .with_content(/^\s+endscript$/)
      end
  end
end
