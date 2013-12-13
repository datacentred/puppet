# Enable hiera with encryption support
# install the keys as puppet:puppet first
# in /etc/puppet/keys
class dc_profile::puppetmaster_hieragpg {

  include hiera_yamlgpg

  class { '::dc_hiera_yamlgpg': }

}
