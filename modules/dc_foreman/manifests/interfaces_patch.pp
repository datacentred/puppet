# Class dc_foreman::interfaces_patch
# install patch to filter out OpenStack interfaces
class dc_foreman::interfaces_patch {

  file { '/usr/share/foreman/app/services/fact_parser.rb':
    ensure  => file,
    owner   => 'foreman',
    group   => 'foreman',
    source  => 'puppet:///modules/dc_foreman/files/fact_parser.rb',
    require => [ Class['::apache'], Class['::foreman::install'] ],
    notify  => Class['::apache::service'],
  }

}
