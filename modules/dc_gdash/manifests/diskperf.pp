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
  $disk = regsubst($title, '\#.*', '\1'),
) {

  include stdlib

  $tplpath = '/var/www/gdash/graph_templates/disk_perf'
  $hostpath="${tplpath}/${_hostname}"

  ensure_resource('file', $hostpath, { 'ensure' => 'directory', 'purge' => 'true' })

  # Evaluate the template outside of the ensure_resource function
  # as it doesn't get evaluated for some reason
  $yaml = template('dc_gdash/disk.dash.yaml.erb')

  ensure_resource('file', "${hostpath}/dash.yaml", { 'ensure' => 'present', 'content' => "$yaml", 'require' => "File[$hostpath]"}) 
  
  # Only graph merged ops for devices and not for partitions or raid devices
  if $disk =~ /^sd[a-z]+$/ {

    file { "${hostpath}/disk_merged_ops.${disk}.graph": 
      content => template('dc_gdash/disk-merged_ops.graph.erb'),
      require => File[$hostpath],
    }

  }

  # Software raid devices don't supply data for IO time
  if $disk !~ /^md[0-9].*/ {

    file { "${hostpath}/disk_time.${disk}.graph": 
      content => template('dc_gdash/disk-time.graph.erb'),
      require => File[$hostpath],
    }
  
  }

  file { "${hostpath}/disk_octets.${disk}.graph": 
    content => template('dc_gdash/disk-octets.graph.erb'),
    require => File[$hostpath],
  }

  file { "${hostpath}/disk_ops.${disk}.graph": 
    content => template('dc_gdash/disk-ops.graph.erb'),
    require => File[$hostpath],
  }

}
