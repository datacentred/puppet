#
# == Class: dc_profile::hardware::irqbalance
#
# See https://bugs.launchpad.net/ubuntu/+source/irqbalance/+bug/1321425
#
class dc_profile::hardware::irqbalance {

  unless $::is_virtual {
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

}
