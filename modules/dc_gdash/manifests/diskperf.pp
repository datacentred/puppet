# Class: dc_gdash::diskperf
#
# Creates a set of graph templates in the host's graph folder
# per disk
#
# Parameters: Title composed of diskname#shorthostname
#
# Actions:
#
# Requires:
#
# Sample Usage: dc_gdash::diskperf { 'sda1#gdash': }
#
define dc_gdash::diskperf (
  $_hostname = regsubst($title, '.*\#', '\1'),
  $_disk = regsubst($title, '\#.*', '\1'),
) {

  $tplpath = '/var/www/gdash/graph_templates'
  $hostpath = "${tplpath}/hosts/${_hostname}"

  file { "${hostpath}/disk_merged_ops.${_disk}.graph": 
    content => template('dc_gdash/disk-merged_ops.graph.erb'),
  }

  file { "${hostpath}/disk_octets.${_disk}.graph": 
    content => template('dc_gdash/disk-octets.graph.erb'),
  }

  file { "${hostpath}/disk_ops.${_disk}.graph": 
    content => template('dc_gdash/disk-ops.graph.erb'),
  }

  file { "${hostpath}/disk_time.${_disk}.graph": 
    content => template('dc_gdash/disk-time.graph.erb'),
  }

}
