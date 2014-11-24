# == Class: dc_ipmi::supermicro::reaper
#
# All our times have come
# Here, but now they're gone
# Seasons don't fear the reaper
# Nor do the wind, the sun or the rain
#
class dc_ipmi::supermicro::reaper {

  file { '/usr/local/bin/ipmi_reaper':
    source => 'puppet:///modules/dc_ipmi/ipmi_reaper',
    owner  => 'root',
    group  => 'root',
    mode   => '0775',
  }

  cron { 'ipmi_reaper':
    command => '/usr/local/bin/ipmi_reaper',
    user    => 'root',
    minute  => 0,
  }

}
