# Class: dc_logstash::client::neutron
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
class dc_logstash::client::neutron (
  $oslofmt_codec_hash=undef,
){
  dc_logstash::client::register { 'neutron_server_log':
    logs   => '/var/log/neutron/server.log',
    fields => {
      'type' => 'neutron_server',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'neutron_metadata_log':
    logs   => '/var/log/neutron/metadata-agent.log',
    fields => {
      'type' => 'neutron_metadata',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'neutron_l3_log':
    logs   => '/var/log/neutron/vpn_agent.log',
    fields => {
      'type' => 'neutron_l3',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'neutron_lbaas_log':
    logs   => '/var/log/neutron/lbaas-agent.log',
    fields => {
      'type' => 'neutron_lbaas',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'neutron_dhcp_log':
    logs   => '/var/log/neutron/dhcp-agent.log',
    fields => {
      'type' => 'neutron_dhcp',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'neutron_metering_log':
    logs   => '/var/log/neutron/metering_agent.log',
    fields => {
      'type' => 'neutron_metering',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'neutron_netns_cleanup_log':
    logs   => '/var/log/neutron/neutron-netns-cleanup.log',
    fields => {
      'type' => 'neutron_netns_cleanup',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'neutron_openvswitch_log':
    logs   => '/var/log/neutron/openvswitch-agent.log',
    fields => {
      'type' => 'neutron_openvswitch',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'openvswitch_ovsdbserver_log':
    logs   => '/var/log/openvswitch/ovsdb-server.log',
    fields => {
      'type' => 'openvswitch_ovsdbserver',
    }
  }

  dc_logstash::client::register { 'openvswitch_ovsctl_log':
    logs   => '/var/log/openvswitch/ovs-ctl.log',
    fields => {
      'type' => 'openvswitch_ovsvctl',
    }
  }

  dc_logstash::client::register { 'openvswitch_ovsvswitchd':
    logs   => '/var/log/openvswitch/ovs-vswitchd.log',
    fields => {
      'type' => 'openvswitch_ovsvswitchd',
    }
  }

}
