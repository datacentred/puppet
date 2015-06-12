# Class: dc_role::osdbmq
#
# Core OpenStack MariaDB / Rabbit MQ
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::osdbmq {

  contain dc_profile::openstack::galera
  contain dc_profile::openstack::rabbitmq
  contain dc_profile::openstack::memcached

  include ::sysctls
  include dc_profile::openstack::neutron_db_check

}
