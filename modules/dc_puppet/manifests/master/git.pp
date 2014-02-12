#
class dc_puppet::master::git {
  contain dc_puppet::master::git::install
  contain dc_puppet::master::git::config
  contain dc_puppet::master::git::environments

  Class['dc_puppet::master::git::install'] ->
  Class['dc_puppet::master::git::config'] ->
  Class['dc_puppet::master::git::environments']
}
