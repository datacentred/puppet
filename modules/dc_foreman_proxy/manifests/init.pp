# Class: dc_foreman_proxy
#
# Foreman_proxy
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_foreman_proxy ( $use_dns = "false", $use_dhcp = "false", $dns_key= "/etc/bind/rndc.key") {

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

}

