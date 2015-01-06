# Class: dc_logstash::client::nova
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
class dc_logstash::client::nova {

  dc_logstash::client::register { 'nova_api':
    logs   => '/var/log/nova/nova-api.log',
    fields => {
      'type' => 'nova-api',
    }
  }

  dc_logstash::client::register { 'nova_conductor':
    logs   => '/var/log/nova/nova-conductor.log',
    fields => {
      'type' => 'nova-conductor',
    }
  }

  dc_logstash::client::register { 'nova_scheduler':
    logs   => '/var/log/nova/nova-scheduler.log',
    fields => {
      'type' => 'nova-scheduler',
    }
  }

  dc_logstash::client::register { 'nova_cert':
    logs   => '/var/log/nova/nova-cert.log',
    fields => {
      'type' => 'nova-cert',
    }
  }

  dc_logstash::client::register { 'nova_manage':
    logs   => '/var/log/nova/nova-manage.log',
    fields => {
      'type' => 'nova-manage',
    }
  }

  dc_logstash::client::register { 'nova_consoleauth':
    logs   => '/var/log/nova/nova-consoleauth.log',
    fields => {
      'type' => 'nova-consoleauth',
    }
  }

}