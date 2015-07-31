#
class dc_collectd::params {
  case $::osfamily {
    'RedHat': {
      $collectdconf = '/etc/collectd.d'
    }
    'Debian': {
      $collectdconf = '/etc/collectd/conf.d'
    }
    default: {}
  }

  $collectdlibs = '/usr/lib/collectd'
  $collectdpylibs = "${collectdlibs}/python"

}
