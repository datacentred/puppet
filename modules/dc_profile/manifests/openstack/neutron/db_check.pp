# Class: dc_profile::openstack::neutron::db_check
#
# Neutron db check script configuration
#
# Parameters:
#
# Actions:
#
#
# Sample Usage:
#
class dc_profile::openstack::neutron::db_check {

  $neutron_host = 'localhost'
  $neutron_db = hiera(neutron_db)
  $neutron_db_user = hiera(neutron_db_user)
  $neutron_db_pass = hiera(neutron_db_pass)

  package { 'python-mysqldb':
    ensure => installed,
  }

  file { '/usr/local/bin/check_neutron_db.py':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('dc_openstack/check_neutron_db.py.erb'),
  }

  cron { 'check_neutron_db':
    command => '/usr/local/bin/check_neutron_db.py',
    user    => 'root',
    hour    => '2',
    minute  => '0',
    require => File['/usr/local/bin/check_neutron_db.py'],
  }

}
