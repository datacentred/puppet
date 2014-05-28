# Class: dc_profile::openstack::nova_logstash
#
# Logstash config for Nova controller node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::nova_logstash {

  dc_logstash::client::register { 'nova_api':
    logs => '/var/log/nova/nova-api.log',
    type => 'nova-api',
  }

  dc_logstash::client::register { 'nova_conductor':
    logs => '/var/log/nova/nova-conductor.log',
    type => 'nova-conductor',
  }

  dc_logstash::client::register { 'nova_scheduler':
    logs => '/var/log/nova/nova-scheduler.log',
    type => 'nova-scheduler',
  }

  dc_logstash::client::register { 'nova_cert':
    logs => '/var/log/nova/nova-cert.log',
    type => 'nova-cert',
  }

  dc_logstash::client::register { 'nova_manage':
    logs => '/var/log/nova/nova-manage.log',
    type => 'nova-manage',
  }

  dc_logstash::client::register { 'nova_consoleauth':
    logs => '/var/log/nova/nova-consoleauth.log',
    type => 'nova-consoleauth',
  }

}
