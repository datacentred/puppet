# Class: dc_gdash::overview
#
# Creates a basic graph template in the host's graph folder
#
# Parameters: Title composed of ifname#shorthostname
#
# Actions:
#
# Requires:
#
# Sample Usage: dc_gdash::overview { 'hostname': }
#
define dc_gdash::overview (
  $_hostname = $title,
) {

  $tplpath = '/var/www/gdash/graph_templates/overview'
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
