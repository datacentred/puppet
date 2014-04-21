# Use this file to define the puppet modules you want to test

contain dc_role::generic
class { 'dc_rails':
  app_name           => 'soleman',
  app_url            => 'soleman.dev',
  app_repo           => 'git@github.com:datacentred/soleman.git',
  ssl_key            => 'puppet:///modules/dc_ssl/soleman/soleman.dev.key',
  ssl_cert           => 'puppet:///modules/dc_ssl/soleman/soleman.dev.crt',
}