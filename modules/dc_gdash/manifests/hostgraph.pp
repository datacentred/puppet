define dc_gdash::hostgraph () {

  $tplpath = '/var/www/gdash/graph_templates/'
  $hostpath = "${tplpath}/${hostname}/collectd/"

  file { "${hostpath}": 
    ensure => directory, 
    require => File[$tplpath] 
  }

  file { "${hostpath}/dash.yaml": 
    content => template('dc_gdash/dash.yaml.erb') 
  }

  file { "${hostpath}/load.graph": 
    content => template('dc_gdash/load.graph') 
  }

  file { "{$hostpath}/memory.graph": 
    content => template('dc_gdash/memory.graph') 
  }

  file { "{$hostpath}/nettraf.graph": 
    content => template('dc_gdash/nettraf.graph') 
  }

}
