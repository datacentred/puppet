# == Class: dc_bmc::debian
#
# Installs the prerequisite components on Debian systems to get ipmitool
# up and running
#
class dc_bmc::debian {

  # We want to load the kernel modules before installing the ipmi services
  include ::dc_bmc::debian::modules
  include ::dc_bmc::debian::install
  include ::dc_bmc::debian::configure
  include ::dc_bmc::debian::service

  Class['::dc_bmc::debian::modules'] ->
  Class['::dc_bmc::debian::install'] ->
  Class['::dc_bmc::debian::configure'] ~>
  Class['::dc_bmc::debian::service']

  # Icinga
  include dc_icinga::hostgroup_bmc

}
