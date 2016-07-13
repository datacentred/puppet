# == Class: dc_collectd::agent::default
#
# installs the basic collectd plugins
class dc_collectd::agent::default {

  ensure_packages('sysstat')

  include ::collectd::plugin::write_graphite

}
