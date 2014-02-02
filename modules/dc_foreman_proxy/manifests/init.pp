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
class dc_foreman_proxy (
  $use_dns = false,
  $use_dhcp = false,
  $use_bmc = false,
  $use_puppetca = false,
  $use_puppet = false,
  $dns_key = '/etc/bind/rndc.key',
  $omapi_key="",
  $omapi_secret="",
  $use_tftp = false,
  $tftproot=""
) {

  validate_bool($use_dns, $use_dhcp, $use_tftp, $use_bmc, $use_puppetca, $use_puppet)

  realize Dc_repos::Virtual::Repo['local_foreman_mirror']

  package { 'foreman-proxy':
    ensure  => installed,
    require => Dc_repos::Virtual::Repo['local_foreman_mirror'],
    name    => 'foreman-proxy',
  }

  file { '/etc/foreman-proxy/settings.yml':
    require => Package['foreman-proxy'],
    owner   => 'foreman-proxy',
    group   => 'foreman-proxy',
    mode    => '0640',
    content => template('dc_foreman_proxy/settings.yml.erb');
  }

  if $use_dns == true {
    File <| title == $dns::params::rndckeypath |> {
      ensure  => present,
      require => Package['foreman-proxy'],
      owner   => 'bind',
      group   => 'foreman-proxy',
    }
  }

  if $use_tftp == true {
    file { "${tftproot}/boot":
      ensure  => directory,
      require => File[$tftproot],
      owner   => 'foreman-proxy',
      group   => 'root',
    }
    file { "${tftproot}/pxelinux.cfg":
      ensure  => directory,
      require => File[$tftproot],
      owner   => 'foreman-proxy',
      group   => 'root',
    }
  }

  if $use_bmc == true {
    package { 'rubyipmi':
      ensure   => installed,
    }
    package { 'ipmitool':
      ensure => installed,
    }
  }

  # The proxy will use the puppet certificates signed by the CA
  user { 'foreman-proxy':
    ensure  => present,
    groups  => 'puppet',
    require => Package['foreman-proxy'],
    notify  => Service['foreman-proxy'],
  }

  # TODO: This will clash with puppet::server::config
  # but I tend to use the community foreman_proxy module
  # so not overly concerned for now - SM
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

  service { 'foreman-proxy':
    ensure    => running,
    require   => Package['foreman-proxy'],
    enable    => true,
    subscribe => File['/etc/foreman-proxy/settings.yml']
  }

}
