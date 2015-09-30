# == Class: dc_profile::puppet::puppet_master
#
# Installs a passenger based puppet master and support
# infrastructure
#
class dc_profile::puppet::puppet_master {

  include ::puppet::master::apache
  include ::puppetdb::master::config
  include ::foreman::puppetmaster
  include ::deepmerge
  include ::puppetdeploy
  include ::dc_icinga::hostgroup_puppetmaster

  Class['::puppet::master'] -> Class['::foreman::puppetmaster']

  ensure_packages('toml', { provider => 'gem' })

}
