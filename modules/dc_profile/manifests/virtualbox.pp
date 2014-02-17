#
class dc_profile::virtualbox {

  package { 'virtualbox-4.3' :
    ensure => installed,
  }

}
