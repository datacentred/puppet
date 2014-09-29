# Class: dc_puppet::master::hipbot::config
#
# Hipbot configuration
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::hipbot::config (
  $xmpp_jid,
  $xmpp_name,
  $xmpp_pass,
  $xmpp_room,
  $xmpp_hipchat_api_token,
  $xmpp_hipchat_api_room,
  $foreman_url,
  $foreman_admin_pw,
) {

  file { [
    '/opt/hipbot',
    '/var/log/hipbot'
    ]:
    ensure => directory,
  } ->

  file { '/opt/hipbot/hipbot.py':
    ensure  => file,
    mode    => '0755',
    content => template('dc_puppet/master/hipbot/hipbot.py.erb'),
  } ->

  file { '/opt/hipbot/robocopy.py':
    ensure  => file,
    content => template('dc_puppet/master/hipbot/robocopy.py.erb'),
  } ->

  file { '/etc/init.d/hipbot':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/dc_puppet/master/hipbot/hipbot',
  }

}

