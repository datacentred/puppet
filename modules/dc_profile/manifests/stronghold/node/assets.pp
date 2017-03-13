# Class: dc_profile::stronghold::node::assets
#
# Configure a Stronghold assets node
#
class dc_profile::stronghold::node::assets {
  include dc_profile::stronghold::firewall
  include ::nginx

  file { '/var/www':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/var/www/html':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/root/.ssh':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/root/.ssh/authorized_keys':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file_line { 'authorized_keys':
    ensure => 'present',
    line   => hiera(stronghold::authorized_key),
    path   => '/root/.ssh/authorized_keys',
  }

  file { '/etc/ssl/certs/STAR_datacentred_io.pem':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => hiera(stronghold::star_datacentred_io_pem),
  }

  file { '/etc/ssl/certs/admin-my.datacentred.io-ca.crt':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => hiera(stronghold::admin_my_datacentred_io_ca_crt)
  }

  firewall { '040 allow HTTP':
    ensure   => 'present',
    proto    => tcp,
    action   => 'accept',
    dport    => 80,
    provider => ['iptables', 'ip6tables'],
  }

  firewall { '050 allow HTTPS':
    ensure   => 'present',
    proto    => tcp,
    action   => 'accept',
    dport    => 443,
    provider => ['iptables', 'ip6tables'],
  }
}
