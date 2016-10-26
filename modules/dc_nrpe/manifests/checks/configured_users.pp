# == Class: dc_nrpe::checks::configured_users
#
class dc_nrpe::checks::configured_users {

  $_usernames_dynamic = keys(hiera('admins'))
  $_usernames_static = ['ceph']
  $_usernames = join(concat($_usernames_dynamic, $_usernames_static), ' ')

  dc_nrpe::check { 'check_configured_users':
    path   => '/usr/local/bin/check_configured_users.py',
    args   => "-u ${_usernames}",
    source => 'puppet:///modules/dc_nrpe/check_configured_users.py',
  }

}
