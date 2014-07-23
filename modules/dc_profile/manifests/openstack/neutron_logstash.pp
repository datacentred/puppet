# Class: dc_profile::openstack::neutron_logstash
#
# Configures logstash for neutron
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::neutron_logstash {

  dc_logstash::client::register { 'neutron_server_log':
    logs     => '/var/log/neutron/server.log',
    fields   => {
      'type' => 'neutron_server',
      'tags' => [ 'neutron', 'oslofmt' ]
    }
  }

  dc_logstash::client::register { 'neutron_metadata_log':
    logs   => '/var/log/neutron/metadata-agent.log',
    fields => {
      'type' => 'neutron_metadata',
      'tags' => [ 'neutron', 'oslofmt' ]
    }
  }

  dc_logstash::client::register { 'neutron_l3_log':
    logs   => '/var/log/neutron/l3-agent.log',
    fields => {
      'type' => 'neutron_l3',
      'tags' => [ 'neutron', 'oslofmt' ]
    }
  }

  dc_logstash::client::register { 'neutron_dhcp_log':
    logs   => '/var/log/neutron/dhcp-agent.log',
    fields => {
      'type' => 'neutron_dhcp',
      'tags' => [ 'neutron', 'oslofmt' ]
    }
  }

  dc_logstash::client::register { 'neutron_metering_log':
    logs   => '/var/log/neutron/metering_agent.log',
    fields => {
      'type' => 'neutron_metering',
      'tags' => [ 'neutron', 'oslofmt' ]
    }
  }

  dc_logstash::client::register { 'neutron_netns_cleanup_log':
    logs   => '/var/log/neutron/neutron-netns-cleanup.log',
    fields => {
      'type' => 'neutron_netns_cleanup',
      'tags' => [ 'neutron', 'oslofmt' ]
    }
  }

  dc_logstash::client::register { 'neutron_openvswitch_log':
    logs   => '/var/log/neutron/openvswitch-agent.log',
    fields => {
      'type' => 'neutron_openvswitch',
      'tags' => [ 'neutron', 'oslofmt' ]
    }
  }

  dc_logstash::client::register { 'openvswitch_ovsdbserver_log':
    logs   => '/var/log/openvswitch/ovsdb-server.log',
    fields => {
      'type' => 'openvswitch_ovsdbserver',
      'tags' => [ 'neutron', 'oslofmt' ]
    }
  }

  dc_logstash::client::register { 'openvswitch_ovsctl_log':
    logs   => '/var/log/openvswitch/ovs-ctl.log',
    fields => {
      'type' => 'openvswitch_ovsvctl',
      'tags' => [ 'neutron', 'oslofmt' ]
    }
  }

  dc_logstash::client::register { 'openvswitch_ovsvswitchd':
    logs   => '/var/log/openvswitch/ovs-vswitchd.log',
    fields => {
      'type' => 'openvswitch_ovsvswitchd',
      'tags' => [ 'neutron', 'oslofmt' ]
    }
  }

}
