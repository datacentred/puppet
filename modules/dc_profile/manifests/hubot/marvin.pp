# Class: dc_profile::hubot::marvin
#
# Provisions a node as a Hubot bot
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::hubot::marvin {

  include ::redis

  package { 'node':} ->
  package { 'nodejs-legacy':} ->
  package {'npm':} ->
  package {'cron':
    ensure   => present,
    provider => 'npm',
  } ->
  package {'time':
    ensure   => present,
    provider => 'npm',
  } ->

  file { '/usr/local/bin/node':
    ensure => 'link',
    target => '/usr/bin/nodejs',
  } ->

  class { 'hubot':
    env_export    => { 'HUBOT_HIPCHAT_JID'               => hiera(hubot::marvin::hipchat_jid),
                       'HUBOT_HIPCHAT_PASSWORD'          => hiera(hubot::marvin::hipchat_password),
                       'HUBOT_HIPCHAT_ROOMS'             => hiera(hubot::marvin::hipchat_rooms),
                       'HUBOT_PAGERDUTY_API_KEY'         => hiera(hubot::marvin::pagerduty::api_key),
                       'HUBOT_PAGERDUTY_SCHEDULE_ID'     => hiera(hubot::marvin::pagerduty::schedule_id),
                       'HUBOT_PAGERDUTY_SERVICE_API_KEY' => hiera(hubot::marvin::pagerduty::service_api_key),
                       'HUBOT_PAGERDUTY_SUBDOMAIN'       => hiera(hubot::marvin::pagerduty::subdomain),
                       'HUBOT_ICINGA_HOST'               => hiera(nagios_api_host),
                       'HUBOT_ICINGA_USER'               => hiera(nagios_api_username),
                       'HUBOT_ICINGA_PASSWORD'           => hiera(nagios_api_password),
                       'HUBOT_OPTS'                      => '-a hipchat',
                      },
    git_source          => 'git@github.com:datacentred/marvin.git',
    ssh_privatekey_file => 'puppet:///modules/dc_puppet/keys/marvin/id_rsa',
    nodejs_manage_repo  => false,
    bot_name            => 'marvin',
    display_name        => 'Marvin',
    adapter             => 'hipchat',
  }

}
