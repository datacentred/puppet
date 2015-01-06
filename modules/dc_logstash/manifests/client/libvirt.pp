# Class: dc_logstash::client::libvirt
#
# Logstash config for libvirt
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_logstash::client::libvirt {

  dc_logstash::client::register { 'libvirt':
    logs   => '/var/log/libvirt/libvirtd.log',
    fields => {
      'type' => 'libvirt',
    }
  }

}
