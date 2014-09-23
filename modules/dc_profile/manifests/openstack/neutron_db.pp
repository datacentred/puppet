# Class: dc_profile::openstack::neutron_db
#
# Openstack Neutron database definitions
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::neutron_db {

  $neutron_db      = hiera(neutron_db)
  $neutron_db_user = hiera(neutron_db_user)
  $neutron_db_pass = hiera(neutron_db_pass)

  dc_mariadb::db { $neutron_db:
    user     => $neutron_db_user,
    password => $neutron_db_pass,
    host     => '%',
    require  => Class['::galera'],
  }

}
