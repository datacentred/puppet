# Class: dc_gdash::hostgraph
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
# Sample Usage: dc_gdash::hostgraph { 'hostname': }
#
define dc_gdash::hostgraph (
  $_hostname = $title,
) {

  $tplpath = '/var/www/gdash/graph_templates/hosts'
  $hostpath = "${tplpath}/${_hostname}"

  file { $hostpath:
    ensure  => directory,
    recurse => true,
  }

  file { "${hostpath}/dash.yaml":
    content => template('dc_gdash/dash.yaml.erb'),
    require => File[$hostpath],
  }

  file { "${hostpath}/load.graph":
    content => template('dc_gdash/load.graph.erb'),
    require => File[$hostpath],
  }

  file { "${hostpath}/memory.graph":
    content => template('dc_gdash/memory.graph.erb'),
    require => File[$hostpath],
  }

}
