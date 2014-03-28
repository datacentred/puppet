# Class: dc_gdash::nettraf
#
# Creates a graph template in the host's graph folder
# per interface
#
# Parameters: Title composed of ifname#shorthostname
#
# Actions:
#
# Requires:
#
# Sample Usage: dc_gdash::nettraf { 'eth0#gdash': }
#
define dc_gdash::nettraf (
  $_hostname = regsubst($title, '.*\#', '\1'),
  $_interface = regsubst($title, '\#.*', '\1'),
) {

  $tplpath = '/var/www/gdash/graph_templates'
  $hostpath = "${tplpath}/hosts/${_hostname}"

  file { "${hostpath}/nettraf.${_interface}.graph": 
    content => template('dc_gdash/nettraf.graph.erb'),
  }

}
