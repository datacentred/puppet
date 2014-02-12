#
class dc_puppet::master {

  contain dc_puppet::master::install
  contain dc_puppet::master::config
  contain dc_puppet::master::service

  Class['dc_puppet::master::install'] ->
  Class['dc_puppet::master::config'] ~>
  Class['dc_puppet::master::service']

}
