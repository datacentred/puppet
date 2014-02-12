#
class dc_puppet::config {
  include dc_puppet::params

  concat_build { 'puppet.conf': }
  concat_fragment { 'puppet.conf+10-main':
    content => template('dc_puppet/puppet.conf-main.erb'),
  }

  file { $dc_puppet::params::dir:
    ensure => directory,
  } ->
  file { "${dc_puppet::params::dir}/puppet.conf":
    source  => concat_output('puppet.conf'),
    require => Concat_build['puppet.conf'],
  }
}
