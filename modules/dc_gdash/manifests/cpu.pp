# Class: dc_gdash::cpu
#
# Creates a set of graph templates in the host's graph folder
# per cpu
#
# Parameters: Title composed of cpu#shorthostname
#
# Actions:
#
# Requires:
#
# Sample Usage: dc_gdash::cpu { 'cpu0#gdash': }
#
define dc_gdash::cpu (
  $_hostname = regsubst($title, '.*\#', '\1'),
  $cpu = regsubst($title, '\#.*', '\1'),
) {

  include stdlib

  $tplpath = '/var/www/gdash/graph_templates/cpu'
  $hostpath="${tplpath}/${_hostname}"

  ensure_resource('file', $hostpath, { 'ensure' => 'directory', 'purge' => 'true' })

  # Evaluate the template outside of the ensure_resource function
  # as it doesn't get evaluated for some reason
  $yaml = template('dc_gdash/cpu.dash.yaml.erb')

  ensure_resource('file', "${hostpath}/dash.yaml", { 'ensure' => 'present', 'content' => "$yaml", 'require' => "File[$hostpath]"}) 

  file { "${hostpath}/cpu.${cpu}.graph": 
    content => template('dc_gdash/cpu.graph.erb'),
    require => File[$hostpath],
  }

}
