# Use this file to define the puppet modules you want to test

contain dc_role::generic
class { 'dc_rails':
  app_name           => 'soleman',
  app_url            => 'soleman.dev',
  app_repo           => 'git@github.com:datacentred/soleman.git',
  password           => 'secret',
  db_password        => 'secret',
  secret_key_base    => 'cb6b5ed8f0d8f2bde735ea8a9cea0162f4324b9fba50fd129715c71f740976317010de61c2e24fcc6dbdc8f61a5242bc22b0c120ea773b511893db810943b12',
  ssl_key            => 'puppet:///modules/dc_ssl/soleman/soleman.dev.key',
  ssl_cert           => 'puppet:///modules/dc_ssl/soleman/soleman.dev.crt',
  deploy_key_private => 'puppet:///modules/dc_rails/deployer_keys/id_rsa',
  deploy_key_public  => 'puppet:///modules/dc_rails/deployer_keys/id_rsa.pub',
}