# Class: dc_profile::openstack::nova_compute_logstash
#
# Logstash config for Nova on compute nodes
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::nova_compute_logstash {

  dc_logstash::client::register { 'nova_manage':
    logs   => '/var/log/nova/nova-manage.log',
    fields => {
      'type' => 'nova-manage',
    }
  }

  dc_logstash::client::register { 'nova_compute':
    logs   => '/var/log/nova/nova-compute.log',
    fields => {
      'type' => 'nova-compute',
    }
  }

}
