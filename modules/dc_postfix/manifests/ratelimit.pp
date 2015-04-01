# == Class: dc_postfix::ratelimit
#
class dc_postfix::ratelimit {

  create_resources ( postfix::config, $dc_postfix::gateway::rate_limit_config_hash )

}
