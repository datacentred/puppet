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

  $init_groups = [ 'puppet' ]

  if $dc_foreman_proxy::use_tftp {
    $tftp_groups = [ 'tftp' ]
  } else {
    $tftp_groups = []
  }

  if $dc_foreman_proxy::use_dns {
    $dns_groups = [ 'bind' ]
  } else {
    $dns_groups = []
  }

  $groups = flatten([$init_groups,$tftp_groups,$dns_groups])

  if $dc_foreman_proxy::use_bmc {
    include dc_foreman_proxy::bmc
  }

  package { 'foreman-proxy':
    ensure => installed,
    name   => 'foreman-proxy',
  }

  # The proxy will use the puppet certificates signed by the CA
  user { 'foreman-proxy':
    ensure  => present,
    groups  => $groups,
    require => Package['foreman-proxy'],
  }

  sudo::conf { 'foreman-proxy':
    content => "foreman-proxy ALL = NOPASSWD: /usr/bin/puppet cert *\n
    Defaults:foreman-proxy !requiretty",
  }

}
