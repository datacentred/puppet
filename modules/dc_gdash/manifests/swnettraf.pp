# Class: dc_gdash::swnettraf
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
# Sample Usage: dc_gdash::swnettraf { 'eth0#gdash': }
#
define dc_gdash::swnettraf (
  $_hostname = regsubst($title, '.*\#', '\1'),
  $_interface = regsubst($title, '\#.*', '\1'),
  $reversedomain,
) {

  $tplpath = '/var/www/gdash/graph_templates/switches'
  $hostpath = "${tplpath}/${_hostname}"

  ensure_resource('file', $hostpath, { 'ensure' => 'directory', 'purge' => 'true' })

  # Evaluate the template outside of the ensure_resource function
  # as it doesn't get evaluated for some reason
  $yaml = template('dc_gdash/nettraf.dash.yaml.erb')
          
  ensure_resource('file', "${hostpath}/dash.yaml", { 'ensure' => 'present', 'content' => "$yaml", 'require' => "File[$hostpath]"})

  file { "${hostpath}/swnettraf.${_interface}.graph": 
    content => template('dc_gdash/swnettraf.graph.erb'),
  }
  
  file { "${hostpath}/swnetpackets.${_interface}.graph": 
    content => template('dc_gdash/swnetpackets.graph.erb'),
  }

  file { "${hostpath}/swneterrors.${_interface}.graph": 
    content => template('dc_gdash/swneterrors.graph.erb'),
  }

  file { "${hostpath}/swnetdropped.${_interface}.graph": 
    content => template('dc_gdash/swnetdropped.graph.erb'),
  }
}
