# Class dc_foreman::interfaces_patch
# install patch to filter out OpenStack interfaces
# and stop orchestration from checking the proxy on interface fact import
class dc_foreman::interfaces_patch {

  file { '/usr/share/foreman/app/services/fact_parser.rb':
    ensure  => file,
    owner   => 'foreman',
    group   => 'foreman',
    source  => 'puppet:///modules/dc_foreman/fact_parser.rb',
    require => Class['::foreman::install'],
    notify  => Class['::apache::service'],
  }

  file { '/usr/share/foreman/app/models/concerns/orchestration/dhcp.rb':
    ensure  => file,
    owner   => 'foreman',
    group   => 'foreman',
    source  => 'puppet:///modules/dc_foreman/dhcp.rb',
    require => Class['::foreman::install'],
    notify  => Class['::apache::service'],
  }

}
