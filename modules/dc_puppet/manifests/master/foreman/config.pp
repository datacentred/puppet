# Class: dc_puppet::master::foreman::config
#
# Puppet master foreman integration
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::foreman::config {

  include dc_puppet::params
  $dir    = $dc_puppet::params::dir
  $libdir = $dc_puppet::params::libdir
  $ssldir = $dc_puppet::params::ssldir

  # See
  # http://theforeman.org/manuals/1.4/index.html#3.5.4PuppetReports
  # http://theforeman.org/manuals/1.4/index.html#3.5.5FactsandtheENC

  $foreman_url = $dc_puppet::params::foreman_url
  $puppet_home = $dc_puppet::params::vardir
  $puppet_user = 'puppet'
  $facts       = 'true'
  $ssl_ca      = "${ssldir}/certs/ca.pem"
  $ssl_cert    = "${ssldir}/certs/${::fqdn}.pem"
  $ssl_key     = "${ssldir}/private_keys/${::fqdn}.pem"

  file { "${dir}/node.rb":
    ensure  => file,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0550',
    content => template('dc_puppet/master/foreman/external_node_v2.rb.erb'),
  }

  file { "${libdir}/reports/foreman.rb":
    ensure  => file,
    mode    => '0644',
    content => template('dc_puppet/master/foreman/foreman-report_v2.rb.erb'),
  }

  # Foreman 1.5 needs this, puppet 3.6 doesn't create it
  file { "${dir}/autosign.conf":
    ensure => file,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0664',
  }

}
