# Class: dc_gdash::nettraf
# 
# Create a graph for network traffic on a per-interface basis
# Expects $title to be in the format ifname-hostname
#
define dc_gdash::nettraf (
  $hostname = regsubst($title, '.*_', '\1'),
  $interface = regsubst($title, '_.*', '\1'),
) {

  $tplpath = '/var/www/gdash/graph_templates'
  $hostpath = "${tplpath}/hosts/${hostname}"

  file { "${hostpath}/nettraf.${interface}.graph": 
    content => template('dc_gdash/nettraf.graph.erb'),
  }

}
