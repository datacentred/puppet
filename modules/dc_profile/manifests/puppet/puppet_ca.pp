# == Class: dc_profile::puppet::puppet_ca
#
# Class add in CA specific stuff e.g. certificate management and backups
#
class dc_profile::puppet::puppet_ca {

  include ::foreman_proxy
  include ::dc_icinga::hostgroup_foreman_proxy

  # Thw number of inotify nodes is terribly low so bump this up so lsyncd
  # doesn't commit suicide constantly
  include ::sysctls
  include ::puppet_sync
  include ::puppetdeploy
  include ::dc_icinga::hostgroup_lsyncd

  # Ensure our inotify nodes are bumped and the user accounts added
  # before attempting to synchronise data to a peer
  Class['::sysctls'] -> Class['::puppet_sync']
  Class['::puppetdeploy'] -> Class['::puppet_sync']

}
