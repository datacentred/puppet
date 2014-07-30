# Class: dc_profile::puppet::mcollective_host
#
# Installs mcollective end point on all hosts
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::puppet::mcollective_host {

  $mco_middleware_password       = hiera(mco_middleware_password)
  $mco_middleware_admin_password = hiera(mco_middleware_admin_password)
  $mco_ssl_path                  = 'modules/dc_mcollective'

  # Install various plugins on all hosts
  # Use the standard ubuntu packages on trusty
  if $::lsbdistcodename == 'trusty' {
    package { [
      'mcollective-plugins-puppetd',
    ]:
      ensure => purged,
    } ->
    package { [
      'mcollective-plugins-filemgr',
      'mcollective-plugins-iptables',
      'mcollective-plugins-nettest',
      'mcollective-plugins-nrpe',
      'mcollective-plugins-package',
      'mcollective-puppet-agent',
      'mcollective-plugins-service',
    ]:
      ensure => latest,
      notify => Service['mcollective'],
    }
  }
  else {
    package { [
      'mcollective-filemgr-agent',
      'mcollective-iptables-agent',
      'mcollective-nettest-agent',
      'mcollective-nrpe-agent',
      'mcollective-package-agent',
      'mcollective-puppet-agent',
      'mcollective-service-agent',
    ]:
      ensure => latest,
      notify => Service['mcollective'],
    }
  }

  # Copy in unpackaged plugins
  file { '/usr/share/mcollective/plugins/mcollective/agent':
    ensure  => directory,
    source  => 'puppet:///modules/dc_mcollective/agent',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    purge   => false,
    recurse => 'remote',
    notify => Service['mcollective'],
  }

  # The message queues will have their own definition of
  # the mcollective class so prevent them from defining
  # the default configuration
  if get_exported_var($::fqdn, 'mco_mq_host', 'DEFAULT') == 'DEFAULT' {

    class { '::mcollective':
      connector                 => 'rabbitmq',
      middleware_hosts          => get_exported_var('', 'mco_mq_host', ''),
      middleware_password       => $mco_middleware_password,
      middleware_admin_password => $mco_middleware_admin_password,
      middleware_ssl            => true,
      securityprovider          => 'ssl',
      ssl_client_certs          => "puppet:///${mco_ssl_path}/client_certs",
      ssl_ca_cert               => "puppet:///${mco_ssl_path}/certs/ca.pem",
      ssl_server_public         => "puppet:///${mco_ssl_path}/certs/server.pem",
      ssl_server_private        => "puppet:///${mco_ssl_path}/private_keys/server.pem",
      classesfile               => '/var/lib/puppet/classes.txt',
    }
    contain 'mcollective'

    mcollective::server::setting { 'registration':
      value => 'agentlist',
    }
    mcollective::server::setting { 'registerinterval':
      value => 900,
    }

  }

}
