# == Class: dc_collectd::agent::haproxy
#
class dc_collectd::agent::haproxy(
  $socket,
  $proxy_monitor,
  $proxy_ignore,
  $verbose,
){

  collectd::plugin::python { 'haproxy':
    modulepath    => '/usr/lib/collectd',
    module        => 'haproxy',
    script_source => 'puppet:///modules/dc_collectd/haproxy.py',
    config        => {
      'Socket'       => $socket,
      'ProxyMonitor' => $proxy_monitor,
      'ProxyIgnore'  => $proxy_ignore,
      'Verbose'      => $verbose,
    },
  }

}
