# Use this file to define the puppet modules you want to test

contain dc_role::generic
class { 'dc_rails':
  app_name => 'soleman',
  app_url => 'soleman.dev',
  app_repo => 'git@github.com:datacentred/soleman.git',
  password => 'secret',
  db_password => 'secret',
  secret_key_base => '91fe5d494f16b1f3bff432c65d1b30a39e8881c0e842ab607f78f44260ea27f5da3b7c24b5347a57c3059858435b8fc6b2f918bc8fb516c34caecd7810aea7e0',
}