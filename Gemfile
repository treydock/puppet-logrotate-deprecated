source "https://rubygems.org"
#source :rubygems

group :development, :test do
  gem 'rake', :require => false
  gem 'vagrant', '~> 1.0.5'
  gem 'sahara', '~> 0.0.13'
  gem 'rspec-puppet', '~> 0.1.6', :require => false
  gem 'puppetlabs_spec_helper', '~> 0.4.1', :require => false
  gem 'puppet-lint', '~> 0.3.2', :require => false
  gem 'travis-lint', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
