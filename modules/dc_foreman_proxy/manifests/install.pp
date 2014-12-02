# Class: dc_foreman_proxy::install
#
# Foreman_proxy install class
#
# Parameters:
#
# Actions:
#
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_foreman_proxy::install {

  include dc_foreman_proxy

  $init_groups = [ 'puppet' ]

  if $dc_foreman_proxy::use_tftp {
    $tftp_groups = [ 'tftp' ]
    contain dc_foreman_proxy::tftp
  }

  if $dc_foreman_proxy::use_dns {
    $dns_groups = [ 'bind' ]
  }

  if $dc_foreman_proxy::use_bmc {
    contain dc_foreman_proxy::bmc
  }

  $groups = flatten([$init_groups,$tftp_groups,$dns_groups])

  package { 'foreman-proxy':
    ensure  => installed,
    name    => 'foreman-proxy',
  }

  file { '/etc/foreman-proxy/settings.yml':
    require => Package['foreman-proxy'],
    owner   => 'foreman-proxy',
    group   => 'foreman-proxy',
    mode    => '0640',
    content => template('dc_foreman_proxy/settings.yml.erb');
  }

  # The proxy will use the puppet certificates signed by the CA
  user { 'foreman-proxy':
    ensure  => present,
    groups  => $groups,
    require => Package['foreman-proxy'],
    notify  => Service['foreman-proxy'],
  }

  sudo::conf { 'foreman-proxy':
    content => 'foreman-proxy ALL=(ALL) NOPASSWD:ALL',
  }

  if $::fqdn != $::puppetmaster {

    file { "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem":
      ensure => file,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0640',
      notify => Service['foreman-proxy'],
    }

    file { '/var/lib/puppet/ssl/private_keys':
      ensure => directory,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0750',
      notify => Service['foreman-proxy'],
    }

  }

  service { 'foreman-proxy':
    ensure    => running,
    require   => Package['foreman-proxy'],
    enable    => true,
    subscribe => File['/etc/foreman-proxy/settings.yml']
  }

}
