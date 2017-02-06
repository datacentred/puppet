# Class: dc_profile::mon::libvirt
#
# Sets up libvirt monitoring via telegraf 
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::mon::libvirt {

  include dc_telegraf_plugins::input::libvirt

}

