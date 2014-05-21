# Class: dc_gdash::mysql
#
# Creates a set of graph templates in the host's graph folder
# 
#
# Parameters: Title composed of dbhost#shorthostname
#
# Actions:
#
# Requires:
#
# Sample Usage: dc_gdash::mysql { 'controller0#controller0': }
#
define dc_gdash::mysql (
  $_hostname = regsubst($title, '.*\#', '\1'),
  $dbhost = regsubst($title, '\#.*', '\1'),
  $reversedomain = $dc_gdash::params::reversedomain
) {

  include stdlib

  $tplpath = '/var/www/gdash/graph_templates/mysql'
  $hostpath="${tplpath}/${_hostname}"

  ensure_resource('file', $hostpath, { 'ensure' => 'directory', 'purge' => 'true' })

  # Evaluate the template outside of the ensure_resource function
  # as it doesn't get evaluated for some reason
  $yaml = template('dc_gdash/mysql.dash.yaml.erb')

  ensure_resource('file', "${hostpath}/dash.yaml", { 'ensure' => 'present', 'content' => "$yaml", 'require' => "File[$hostpath]"}) 

  file { "${hostpath}/mysqltraf.${dbhost}.graph": 
    content => template('dc_gdash/mysqltraf.graph.erb'),
    require => File[$hostpath],
  }

  file { "${hostpath}/mysqlthreads.${dbhost}.graph": 
    content => template('dc_gdash/mysqlthreads.graph.erb'),
    require => File[$hostpath],
  }
  
  file { "${hostpath}/mysqlcache_results.${dbhost}.graph": 
    content => template('dc_gdash/mysqlcache_results.graph.erb'),
    require => File[$hostpath],
  }
  
  file { "${hostpath}/mysqllocks.${dbhost}.graph": 
    content => template('dc_gdash/mysqllocks.graph.erb'),
    require => File[$hostpath],
  }
}
