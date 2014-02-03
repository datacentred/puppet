#
# Class: dc_profile::collectd
#
class dc_profile::collectd {
  class { 'dc_collectd':
    graphite_server => hiera(graphite_server),
  }
}
