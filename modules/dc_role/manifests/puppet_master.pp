# == Class: dc_role::puppet_master
#
# Installs a puppet master, complete with git based repo, github
# and hipchat integration
#
class dc_role::puppet_master inherits dc_role {

  include ::dc_profile::puppet::puppet_master

}
