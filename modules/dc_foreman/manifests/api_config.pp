# Class dc_foreman::api_config
# Configures API connectivity
class dc_foreman::api_config (
  $foreman_url,
  $foreman_view_api_pw,
  $foreman_view_api_user,
){

  if versioncmp($::puppetversion, '4.0.0') >= 0 {
    $_key = "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem"
    $_cert = "/etc/puppetlabs/puppet/ssl/certs/${::fqdn}.pem"
    $_cacert = '/etc/puppetlabs/puppet/ssl/certs/ca.pem'
  } else {
    $_key = "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem"
    $_cert = "/var/lib/puppet/ssl/certs/${::fqdn}.pem"
    $_cacert = '/var/lib/puppet/ssl/certs/ca.pem'
  }

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/usr/local/lib/python2.7/dist-packages/dc_foreman.py':
    ensure => file,
    source => 'puppet:///modules/dc_foreman/dc_foreman.py'
  }

  file { '/usr/local/etc/foreman_api.config':
    ensure  => file,
    content => template('dc_foreman/foreman_api_config.erb'),
  }

}
