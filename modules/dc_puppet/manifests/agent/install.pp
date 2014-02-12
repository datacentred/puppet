#
class dc_puppet::agent::install {
  include dc_puppet::params

  package { 'puppet':
    ensure => $dc_puppet::params::version,
  }
}
