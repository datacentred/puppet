# Mcollective host, applies to all hosts
class dc_profile::mcollective_host {

  $mco_middleware_password       = hiera(mco_middleware_password)
  $mco_middleware_admin_password = hiera(mco_middleware_admin_password)
  $mco_ssl_path                  = 'modules/dc_mcollective'

  # The message queues will have their own definition of
  # the mcollective class so prevent them from defining
  # the default configuration
  if get_exported_var($::fqdn, 'mco_mq_host', 'DEFAULT') == 'DEFAULT' {
    anchor { 'dc_profile::mcollective_host::first': } ->
    class { '::mcollective':
      connector                 => 'rabbitmq',
      middleware_hosts          => get_exported_var('', 'mco_mq_host', ''),
      middleware_password       => $mco_middleware_password,
      middleware_admin_password => $mco_middleware_admin_password,
      middleware_ssl            => true,
      securityprovider          => 'ssl',
      ssl_client_certs          => "puppet:///${mco_ssl_path}/client_certs",
      ssl_ca_cert               => "puppet:///${mco_ssl_path}/certs/ca.pem",
      ssl_server_public         => "puppet:///${mco_ssl_path}/certs/server.pem",
      ssl_server_private        => "puppet:///${mco_ssl_path}/private_keys/server.pem",
    } ->
    anchor { 'dc_profile::mcollective_host::last': }
  }

}
