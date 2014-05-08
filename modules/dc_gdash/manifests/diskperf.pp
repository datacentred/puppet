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
  $hostname = regsubst($title, '.*\#', '\1'),
  $disk = regsubst($title, '\#.*', '\1'),
) {

  $tplpath = '/var/www/gdash/graph_templates'
  $hostpath = "${tplpath}/hosts/${hostname}"

  file { "${hostpath}/disk_merged_ops.${disk}.graph": 
    content => template('dc_gdash/disk_merged_ops.graph.erb'),
  }

  file { "${hostpath}/disk_octets.${disk}.graph": 
    content => template('dc_gdash/disk_octets.graph.erb'),
  }

  file { "${hostpath}/disk_ops.${disk}.graph": 
    content => template('dc_gdash/disk_ops.graph.erb'),
  }

  file { "${hostpath}/disk_time.${disk}.graph": 
    content => template('dc_gdash/disk_time.graph.erb'),
  }

}
