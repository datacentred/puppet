# Class: dc_puppetmaster
#
# DataCentred's take on a puppet master, done simply
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   class { 'dc_puppetmaster':
#   }
#
#
class dc_puppetmaster {

  class { 'dc_puppetmaster::git::install': } ~>
  class { 'dc_puppetmaster::git::config': } ~>
  class { 'dc_puppetmaster::errbot::install': } ~>
  class { 'dc_puppetmaster::errbot::config': } ~>
  class { 'dc_puppetmaster::errbot::service': } ~>
  class { 'dc_puppetmaster::install': } ~>
  class { 'dc_puppetmaster::config': } ~>
  Class['dc_puppetmaster']

}
