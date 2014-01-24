# Mcollective message queue.  If you add a new message queue
# please add to the mco_middleware_hosts array in
# hieradata/common.yaml
class dc_profile::mcollective_mq {

  $mco_middleware_hosts          = hiera(mco_middleware_hosts)
  $mco_middleware_password       = hiera(mco_middleware_password)
  $mco_middleware_admin_password = hiera(mco_middleware_admin_password)
  $mco_ssl_path                  = 'modules/dc_mcollective'

  anchor { 'dc_profile::mcollective_mq::first': } ->
  class { '::mcollective':
    connector                 => 'rabbitmq',
    middleware                => true,
    middleware_hosts          => $mco_middleware_hosts,
    middleware_password       => $mco_middleware_password,
    middleware_admin_password => $mco_middleware_admin_password,
    middleware_ssl            => true,
    delete_guest_user         => true,
    securityprovider          => 'ssl',
    ssl_client_certs          => "puppet:///${mco_ssl_path}/client_certs",
    ssl_ca_cert               => "puppet:///${mco_ssl_path}/certs/ca.pem",
    ssl_server_public         => "puppet:///${mco_ssl_path}/certs/server.pem",
    ssl_server_private        => "puppet:///${mco_ssl_path}/private_keys/server.pem",
  } ->
  anchor { 'dc_profile::mcollective_mq::last': }

}
