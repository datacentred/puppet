#
class dc_profile::hardware::x9drt {

  # Fix for bug present in irqbalance that only manifests itself in X9DRTs
  # See https://bugs.launchpad.net/ubuntu/+source/irqbalance/+bug/1321425
  unless $::operatingsystem == 'RedHat' {
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
