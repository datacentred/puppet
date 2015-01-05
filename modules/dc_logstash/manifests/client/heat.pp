# Class: dc_logstash::client::heat
#
# Configures logstash for heat
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_logstash::client::heat {

  dc_logstash::client::register { 'heat_api_log':
    logs   => '/var/log/heat/heat-api.log',
    fields => {
      'type' => 'heat',
    }
  }

  dc_logstash::client::register { 'heat_api_cfn_log':
    logs   => '/var/log/heat/heat-api-cfn.log',
    fields => {
      'type' => 'heat',
    }
  }

  dc_logstash::client::register { 'heat_engine_log':
    logs   => '/var/log/heat/heat-engine.log',
    fields => {
      'type' => 'heat',
    }
  }

  dc_logstash::client::register { 'heat_manage_log':
    logs   => '/var/log/heat/heat-manage.log',
    fields => {
      'type' => 'heat',
    }
  }

}
