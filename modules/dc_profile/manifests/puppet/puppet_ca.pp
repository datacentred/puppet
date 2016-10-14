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
  include ::dc_icinga::hostgroup_lsyncd

}
