#
# Install basic set of plugins for monitoring
#
class dc_collectd::plugins {

  class { 'collectd::plugin::load': }

  class { 'collectd::plugin::memory': }

  class { 'collectd::plugin::interface': 
    interfaces => split($::interfaces, ',')
  }

  # Send it all to Graphite via carbon...
  class { 'collectd::plugin::write_graphite':
    graphitehost => hiera(graphite_server)
  }

}
