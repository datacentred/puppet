# Class: dc_profile::perf::grafana
#
# Installation of Grafana dashboard
# http://grafana.org
#
# Parameters:
#
# Actions:
#
# Requires: puppet-grafana, puppetlabs-apache, archive
#
# Sample Usage:
#
class dc_profile::perf::grafana {

  include ::apache
  include ::grafana

}
