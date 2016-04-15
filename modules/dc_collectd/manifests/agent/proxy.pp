# Class: dc_collectd::agent::proxy
#
# Installs network plugin as a proxy
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#  $listeners and $servers need to be hashes
#
class dc_collectd::agent::proxy (
  $user,
  $password,
  $servers,
  $listeners,
){

  file { '/etc/collectd_auth':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => "${user}: ${password}",
  }->
  class { '::collectd::plugin::network':
    forward   => true,
    servers   => $servers,
    listeners => $listeners,
  }

}
