# == Class: dc_nrpe::checks::configured_users
#
class dc_nrpe::checks::configured_users {

  $usernames = keys(hiera('admins'))
  $user_list = inline_template('<%= @usernames.join(" ") %>')

  dc_nrpe::check { 'check_configured_users':
    path   => '/usr/local/bin/check_configured_users.py',
    args   => "-u ${user_list}",
    source => 'puppet:///modules/dc_nrpe/check_configured_users.py',
  }

}
