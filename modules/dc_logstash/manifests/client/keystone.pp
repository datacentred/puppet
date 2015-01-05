# Class: dc_logstash::client::keystone
#
# Configures logstash for keystone
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_logstash::client::keystone {

  dc_logstash::client::register { 'keystone_log':
    logs     => '/var/log/keystone/keystone.log',
    fields   => {
      'type' => 'keystone',
    }
  }

}
