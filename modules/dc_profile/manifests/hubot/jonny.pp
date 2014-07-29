# Class: dc_profile::hubot::jonny
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
class dc_profile::hubot::jonny {

  include ::redis

  package { 'node':} ->
  package { 'nodejs-legacy':} ->
  package {'npm':} ->

  file { '/usr/local/bin/node':
    ensure => 'link',
    target => '/usr/bin/nodejs',
  } ->

  class { 'hubot':
    env_export    => { 'HUBOT_HIPCHAT_JID'               => hiera(hubot::jonny::hipchat_jid),
                       'HUBOT_HIPCHAT_PASSWORD'          => hiera(hubot::jonny::hipchat_password),
                       'HUBOT_HIPCHAT_ROOMS'             => hiera(hubot::jonny::hipchat_rooms),
                       'HUBOT_OPTS'                      => '-a hipchat',
                      },
    git_source          => 'git@github.com:datacentred/jonny.git',
    ssh_privatekey_file => 'puppet:///modules/dc_puppet/keys/marvin/id_rsa',
    nodejs_manage_repo  => false,
    bot_name            => 'jonny',
    display_name        => 'Jonny',
    adapter             => 'hipchat',
  }

}
