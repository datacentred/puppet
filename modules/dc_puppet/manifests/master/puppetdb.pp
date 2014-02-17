# Class: dc_puppet::master::puppetdb
#
# PuppetDB manifest
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::puppetdb {

  contain dc_puppet::master::puppetdb::install
  contain dc_puppet::master::puppetdb::config

}
