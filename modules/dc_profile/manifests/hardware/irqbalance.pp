#
# == Class: dc_profile::hardware::irqbalance
#
# Fix for bug present in irqbalance that only manifests itself in X9
# and X10-based SuperMicro nodes
# See https://bugs.launchpad.net/ubuntu/+source/irqbalance/+bug/1321425
#
class dc_profile::hardware::irqbalance {

  service { 'irqbalance':
    ensure    => running,
    hasstatus => true,
    enable    => true,
  }

  file_line { 'irqbalance':
    path   => '/etc/default/irqbalance',
    line   => 'OPTIONS="--hintpolicy=ignore"',
    notify => Service['irqbalance'],
  }

}
