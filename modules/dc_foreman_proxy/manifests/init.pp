# Class: dc_foreman_proxy
#
# Foreman_proxy
#
# Parameters:
#
# Actions:
#
# Requires: puppetlabs/stdlib
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_foreman_proxy ( $use_dns = false, $use_dhcp = false, $dns_key= '/etc/bind/rndc.key') {

  validate_bool($use_dns)
  validate_bool($use_dhcp)

  realize Dc_repos::Virtual::Repo['local_foreman_mirror']

  package { 'foreman-proxy':
    ensure  => installed,
    require => Dc_repos::Virtual::Repo['local_foreman_mirror'],
    name    => 'foreman-proxy',
  }

  file { '/etc/foreman-proxy/settings.yml':
    owner   => root,
    group   => root,
    mode    => '0640',
    content => template('dc_foreman_proxy/settings.yml.erb');
  }

  if $use_dns == true {
    file { '/etc/bind/rndc.key':
      ensure  => present,
      require => Package['foreman-proxy'],
      owner   => root,
      group   => foreman-proxy,
    }
  }

}

