define dc_gdash::netgraph (
  $interface = $title,
  $hostname,
) {

  $tplpath = '/var/www/gdash/graph_templates'
  $hostpath = "${tplpath}/hosts/${hostname}"

  file { "${hostpath}":
    ensure  => directory,
    recurse => true,
  }

  file { "${hostpath}/nettraf.${interface}.graph": 
    content => template('dc_gdash/nettraf.graph.erb'), 
  }

}
