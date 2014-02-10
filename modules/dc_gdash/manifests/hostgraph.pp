define dc_gdash::hostgraph (
  $hostname = $title 
) {

  $tplpath = '/var/www/gdash/graph_templates'
  $hostpath = "${tplpath}/hosts/${hostname}"

  file { "${hostpath}":
    ensure  => directory,
    recurse => true,
  }

  file { "${hostpath}/dash.yaml": 
    content => template('dc_gdash/dash.yaml.erb'),
  }

  file { "${hostpath}/load.graph": 
    content => template('dc_gdash/load.graph.erb'),
  }

  file { "${hostpath}/memory.graph": 
    content => template('dc_gdash/memory.graph.erb'),
  }

  file { "${hostpath}/nettraf.graph": 
    content => template('dc_gdash/nettraf.graph.erb'), 
  }

}
