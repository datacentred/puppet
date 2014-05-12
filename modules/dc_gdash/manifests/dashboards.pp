# Class: dc_gdash::dashboards
#
# Creates top level dash folders 
#
#
# Actions:
#
# Requires:
#
#
class dc_gdash::dashboards {

  $tplpath = '/var/www/gdash/graph_templates/'
  $disktplpath = "${tplpath}/disk_perf"
  $nettplpath = "${tplpath}/network"
  $overviewtplpath = "${tplpath}/overview"
  $dftplpath = "${tplpath}/df"
  $cputplpath = "${tplpath}/cpu"

  file { $tplpath:
    ensure  => directory,
  }
  
  file { $disktplpath:
    ensure  => directory,
    purge   => true,
    require => File[$tplpath]
  }

  file { $nettplpath:
    ensure  => directory,
    purge   => true,
    require => File[$tplpath]
  }

  file { $overviewtplpath:
    ensure  => directory,
    purge   => true,
    require => File[$tplpath]
  }
}
