# == Class: dc_postfix::networks
#
class dc_postfix::networks {

  create_resources ( postfix::config, $dc_postfix::gateway::networks_config_hash )

}
