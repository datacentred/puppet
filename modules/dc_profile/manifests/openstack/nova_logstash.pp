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
    logs   => '/var/log/nova/nova-api.log',
    fields => {
      'type' => 'nova-api',
      'tags' => 'oslofmt',
    }
  }

  dc_logstash::client::register { 'nova_conductor':
    logs   => '/var/log/nova/nova-conductor.log',
    fields => {
      'type' => 'nova-conductor',
      'tags' => 'oslofmt',
    }
  }

  dc_logstash::client::register { 'nova_scheduler':
    logs   => '/var/log/nova/nova-scheduler.log',
    fields => {
      'type' => 'nova-scheduler',
      'tags' => 'oslofmt',
    }
  }

  dc_logstash::client::register { 'nova_cert':
    logs   => '/var/log/nova/nova-cert.log',
    fields => {
      'type' => 'nova-cert',
      'tags' => 'oslofmt',
    }
  }

  dc_logstash::client::register { 'nova_manage':
    logs   => '/var/log/nova/nova-manage.log',
    fields => {
      'type' => 'nova-manage',
      'tags' => 'oslofmt',
    }
  }

  dc_logstash::client::register { 'nova_consoleauth':
    logs   => '/var/log/nova/nova-consoleauth.log',
    fields => {
      'type' => 'nova-consoleauth',
      'tags' => 'oslofmt',
    }
  }

}
