#
# == Class: dc_profile::hardware::irqbalance
#
# See https://bugs.launchpad.net/ubuntu/+source/irqbalance/+bug/1321425
#
class dc_profile::hardware::irqbalance {

  unless $::is_virtual {

    ensure_packages('irqbalance')

    Package['irqbalance'] ->

    file_line { 'irqbalance':
      path => '/etc/default/irqbalance',
      line => 'OPTIONS="--hintpolicy=ignore"',
    } ~>

    service { 'irqbalance':
      ensure    => running,
      hasstatus => true,
      enable    => true,
    }

  }

}
