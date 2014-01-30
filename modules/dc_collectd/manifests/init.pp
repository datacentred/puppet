# Class: dc_collectd
#
# collectd - gather statistics and fire them into carbon for graphing
# and analysis
#
class dc_collectd {
  class { 'dc_collectd::install': } ->
  class { 'dc_collectd::plugins': } ->
  Class ['dc_collectd']
}
