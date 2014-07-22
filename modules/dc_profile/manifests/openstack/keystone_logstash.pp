# Class: dc_profile::openstack::keystone_logstash
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
class dc_profile::openstack::keystone_logstash {

  dc_logstash::client::register { 'keystone_log':
    logs   => '/var/log/keystone/keystone.log',
    fields => {
      'type'   => 'keystone',
    }
  }

}
