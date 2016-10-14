# == Class: dc_profile::puppet::puppet_master
#
# Installs a passenger based puppet master and support
# infrastructure
#
class dc_profile::puppet::puppet_master {

  include ::puppetdeploy
  include ::dc_icinga::hostgroup_puppetmaster

}
