# == Class: dc_profile::puppet::puppet_master
#
# Installs a passenger based puppet master and support
# infrastructure
#
class dc_profile::puppet::puppet_master {

  include ::puppet::master::apache
  include ::puppetdb::master::config
  include ::foreman::puppetmaster
  include ::dc_foreman_proxy
  include ::dc_puppet::master::git
  include ::dc_puppet::master::hipbot
  include ::dc_puppet::master::deep_merge
  include ::dc_icinga::hostgroup_puppetmaster
  include ::dc_icinga::hostgroup_foreman_proxy
  include ::dc_profile::puppet::duplicity_puppetcerts

  # Install these classes after puppetmaster-common due to implicit
  # dependencies on directories and SSL certificates.  In particular
  # the foreman proxy messes up the CA provisioning if allowed to run
  # before the master has run
  Class['::puppet::master'] -> Class['::foreman::puppetmaster']
  Class['::puppet::master'] -> Class['::dc_foreman_proxy']
  Class['::puppet::master'] -> Class['::dc_puppet::master::git']

}
