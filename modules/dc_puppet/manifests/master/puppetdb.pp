#
class dc_puppet::master::puppetdb {
  contain dc_puppet::master::puppetdb::install
  contain dc_puppet::master::puppetdb::config
}
