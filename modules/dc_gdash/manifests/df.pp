# Class: dc_gdash::df
#
# Creates a set of graph templates in the host's graph folder
# per disk
#
# Parameters: Title composed of mountname#shorthostname
#
# Actions:
#
# Requires:
#
# Sample Usage: dc_gdash::df { '/var#gdash': }
#
define dc_gdash::df (
  $_hostname = regsubst($title, '.*\#', '\1'),
  $mount = regsubst($title, '\#.*', '\1'),
) {

  include stdlib

  $tplpath = '/var/www/gdash/graph_templates/df'
  $hostpath="${tplpath}/${_hostname}"

  ensure_resource('file', $hostpath, { 'ensure' => 'directory', 'purge' => 'true' })

  # Evaluate the template outside of the ensure_resource function
  # as it doesn't get evaluated for some reason
  $yaml = template('dc_gdash/df.dash.yaml.erb')

  ensure_resource('file', "${hostpath}/dash.yaml", { 'ensure' => 'present', 'content' => "$yaml", 'require' => "File[$hostpath]"}) 

  file { "${hostpath}/df_inodes.${mount}.graph": 
    content => template('dc_gdash/df_inodes.graph.erb'),
    require => File[$hostpath],
  }

  file { "${hostpath}/df_complex.${mount}.graph": 
    content => template('dc_gdash/df-complex.graph.erb'),
    require => File[$hostpath],
  }

}
