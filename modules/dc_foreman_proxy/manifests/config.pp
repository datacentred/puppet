# Class: dc_foreman_proxy::config
#
# Foreman_proxy configuration
#
# Parameters:
#
# Actions:
#
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_foreman_proxy::config {

  include dc_foreman_proxy

  File {
    owner   => 'foreman-proxy',
    group   => 'foreman-proxy',
    mode    => '0640',
  }

  file { '/etc/foreman-proxy/settings.d/bmc.yml':
    content => template('dc_foreman_proxy/bmc.yml.erb'),
  }

  file { '/etc/foreman-proxy/settings.d/dhcp.yml':
    content => template('dc_foreman_proxy/dhcp.yml.erb'),
  }

  file { '/etc/foreman-proxy/settings.d/dns.yml':
    content => template('dc_foreman_proxy/dns.yml.erb'),
  }

  file { '/etc/foreman-proxy/settings.d/tftp.yml':
    content => template('dc_foreman_proxy/tftp.yml.erb'),
  }

  file { '/etc/foreman-proxy/settings.d/puppetca.yml':
    content => template('dc_foreman_proxy/puppetca.yml.erb'),
  }

  file { '/etc/foreman-proxy/settings.d/puppet.yml':
    content => template('dc_foreman_proxy/puppet.yml.erb'),
  }

  file { '/etc/foreman-proxy/settings.yml':
    content => template('dc_foreman_proxy/settings.yml.erb'),
  }

  if $::fqdn != $::puppetmaster {

    file { "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem":
      ensure => file,
      owner  => 'puppet',
      group  => 'puppet',
    }

    file { '/var/lib/puppet/ssl/private_keys':
      ensure => directory,
      owner  => 'puppet',
      group  => 'puppet',
    }

  }

  # How foreman signs certificates
  file { '/etc/puppet/autosign.conf':
    ensure => file,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0664',
  }

}
