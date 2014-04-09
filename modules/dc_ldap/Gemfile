source "http://rubygems.org"

gem "puppet", ENV['PUPPET_VERSION'] || '~> 3.2.0'
gem 'net-ldap'

group :development, :test do
  gem "rake"
  gem "puppet-lint"
  gem "rspec-puppet", '~> 1.0.0'
  gem "puppetlabs_spec_helper"
  gem "puppet-syntax"  
  gem "mocha"
end