# Class: dc_bmc::foreman
#
# Configures Foreman BMC integration
#
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
class dc_bmc::foreman {

  package { 'python-requests':
    ensure => installed,
  }

  file { '/usr/local/bin/omapi_unset_ipmi.sh':
    ensure  => file,
    mode    => '0755',
    content => template('dc_bmc/omapi_unset_ipmi.sh.erb'),
  }

  file { '/usr/local/bin/create_bmc_foreman.py':
    ensure  => file,
    mode    => '0755',
    content => template('dc_bmc/create_bmc_foreman.py.erb'),
  }

  runonce { 'update_foreman_bmc':
    persistent => true,
    command    => '/usr/local/bin/create_bmc_foreman.py',
    require    => [ Package['python-requests'], File['/usr/local/bin/create_bmc_foreman.py'], File['/usr/local/bin/omapi_unset_ipmi.sh'] ]
  }

}
