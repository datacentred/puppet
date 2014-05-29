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
    logs => '/var/log/neutron/server.log',
    type => 'neutron_server',
  }

  dc_logstash::client::register { 'neutron_metadata_log':
    logs => '/var/log/neutron/metadata-agent.log',
    type => 'neutron_metadata',
  }

  dc_logstash::client::register { 'neutron_l3_log':
    logs => '/var/log/neutron/l3-agent.log',
    type => 'neutron_l3',
  }  
  
  dc_logstash::client::register { 'neutron_dhcp_log':
    logs => '/var/log/neutron/dhcp-agent.log',
    type => 'neutron_dhcp',
  }

  dc_logstash::client::register { 'neutron_metering_log':
    logs => '/var/log/neutron/metering_agent.log',
    type => 'neutron_metering',
  }

  dc_logstash::client::register { 'neutron_netns_cleanup_log':
    logs => '/var/log/neutron/neutron-netns-cleanup.log',
    type => 'neutron_netns_cleanup',
  }

  dc_logstash::client::register { 'neutron_openvswitch_log':
    logs => '/var/log/neutron/openvswitch-agent.log',
    type => 'neutron_openvswitch',
  }

}
