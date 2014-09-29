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
  $reversedomain = $dc_gdash::params::reversedomain,
) {

  $tplpath = '/var/www/gdash/graph_templates/network'
  $hostpath = "${tplpath}/${_hostname}"

  ensure_resource('file', $hostpath, {
    'ensure' => 'directory',
    'purge'  => true,
  })

  # Evaluate the template outside of the ensure_resource function
  # as it doesn't get evaluated for some reason
  $yaml = template('dc_gdash/nettraf.dash.yaml.erb')

  ensure_resource('file', "${hostpath}/dash.yaml", {
    'ensure'  => 'present',
    'content' => $yaml,
    'require' => File[$hostpath],
  })

  file { "${hostpath}/nettraf.${_interface}.graph":
    content => template('dc_gdash/nettraf.graph.erb'),
  }

  file { "${hostpath}/netpackets.${_interface}.graph":
    content => template('dc_gdash/netpackets.graph.erb'),
  }

  file { "${hostpath}/neterrors.${_interface}.graph":
    content => template('dc_gdash/neterrors.graph.erb'),
  }
}
