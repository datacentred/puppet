# Mcollective message queue.
class dc_profile::mcollective_mq {

  $mco_middleware_password       = hiera(mco_middleware_password)
  $mco_middleware_admin_password = hiera(mco_middleware_admin_password)
  $mco_ssl_path                  = 'modules/dc_mcollective'

  # Export a variable to the puppet master for this host,
  # it will control on subsequent runs whether to install the
  # middleware, and also elastically define the middleware
  # host pool
  exported_vars::set { 'mco_mq_host':
    value => $::fqdn,
  }

  # Yes we do need to perform this check as the generic mcollective
  # server definition will have been included until the exported
  # variable appears on the puppet master
  if get_exported_var($::fqdn, 'mco_mq_host', 'DEFAULT') != 'DEFAULT' {
    anchor { 'dc_profile::mcollective_mq::first': } ->
    class { '::mcollective':
      connector                 => 'rabbitmq',
      middleware                => true,
      middleware_hosts          => get_exported_var('', 'mco_mq_host', ''),
      middleware_password       => $mco_middleware_password,
      middleware_admin_password => $mco_middleware_admin_password,
      middleware_ssl            => true,
      delete_guest_user         => true,
      securityprovider          => 'ssl',
      ssl_client_certs          => "puppet:///${mco_ssl_path}/client_certs",
      ssl_ca_cert               => "puppet:///${mco_ssl_path}/certs/ca.pem",
      ssl_server_public         => "puppet:///${mco_ssl_path}/certs/server.pem",
      ssl_server_private        => "puppet:///${mco_ssl_path}/private_keys/server.pem",
      require                   => Dc_repos::Virtual::Repo['local_puppetlabs_mirror'],
    } ->
    anchor { 'dc_profile::mcollective_mq::last': }
  }

}
