# Definition: dc_collectd::snmptarget
# List of SNMP targets we'd like to configure 
# collectd's snmp plugin to monitor for us
#
class dc_collectd::snmptarget {
  
  # The devrack Cisco SG300
  @dc_collectd::virtual::snmpvirtual { 'sg300':
    host => 'sg300',
    ip   => '10.10.10.2',
  }

  # Cisco 3560G at the top of Ark's Rack 3
  @dc_collectd::virtual::snmpvirtual { 'ark-rack3-3560g-top':
    host => 'ark-rack3-3560g-top',
    ip   => '10.10.32.2',
  }

  @dc_collectd::virtual::snmpvirtual { 'ark-rack3-3560g-bottom':
    host => 'ark-rack3-3560g-bottom',
    ip   => '10.10.32.3',
  }

  Dc_collectd::Virtual::Snmpvirtual <| |>

}
