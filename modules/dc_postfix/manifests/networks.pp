# == Class: dc_postfix::networks
#
class dc_postfix::networks {

  $client_nets_joined = join( hiera('client_networks'), ', ')

  postfix::config { 'mynetworks':
    value => "127.0.0.0/8, ${client_nets_joined}",
  }

  create_resources ( postfix::config, $dc_postfix::gateway::networks_config_hash )

}
