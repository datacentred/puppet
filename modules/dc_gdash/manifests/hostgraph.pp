define dc_gdash::hostgraph (
  $hostname = $title 
) {

  $tplpath = '/var/www/gdash/graph_templates'
  $hostpath = "${tplpath}/${hostname}"

  file { $hostpath: 
    ensure  => directory,
    recurse => true,
  }

  file { "${hostpath}/dash.yaml": 
    content => template('dc_gdash/dash.yaml.erb'),
    require => File[ $hostpath ], 
  }

  file { "${hostpath}/load.graph": 
    content => template('dc_gdash/load.graph.erb'),
    require => File[ $hostpath ], 
  }

  file { "${hostpath}/memory.graph": 
    content => template('dc_gdash/memory.graph.erb'),
    require => File[ $hostpath ], 
  }

  file { "${hostpath}/nettraf.graph": 
    content => template('dc_gdash/nettraf.graph.erb'), 
    require => File[ $hostpath ], 
  }

}
