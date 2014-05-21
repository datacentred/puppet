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
  $swtplpath = "${tplpath}/switches"
  $overviewtplpath = "${tplpath}/overview"
  $dftplpath = "${tplpath}/df"
  $cputplpath = "${tplpath}/cpu"
  $mysqltplpath = "${tplpath}/mysql"

  file { $tplpath:
    ensure  => directory,
    notify  => Service['apache2'],
  }
  
  file { $disktplpath:
    ensure  => directory,
    purge   => true,
    require => File[$tplpath]
    notify  => Service['apache2'],
  }

  file { $nettplpath:
    ensure  => directory,
    purge   => true,
    require => File[$tplpath]
    notify  => Service['apache2'],
  }

  file { $swtplpath:
    ensure  => directory,
    purge   => true,
    require => File[$tplpath]
    notify  => Service['apache2'],
  }

  file { $overviewtplpath:
    ensure  => directory,
    purge   => true,
    require => File[$tplpath]
    notify  => Service['apache2'],
  }

  file { $dftplpath:
    ensure  => directory,
    purge   => true,
    require => File[$tplpath],
    notify  => Service['apache2'],
  }
  
  file { $cputplpath:
    ensure  => directory,
    purge   => true,
    require => File[$tplpath],
    notify  => Service['apache2'],
  }
  
  file { $mysqltplpath:
    ensure  => directory,
    purge   => true,
    require => File[$tplpath],
    notify  => Service['apache2'],
  }

}
