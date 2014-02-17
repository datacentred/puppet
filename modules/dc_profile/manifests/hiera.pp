#
class dc_profile::hiera {

  package { 'hiera':
    ensure   => installed,
    provider => gem,
  }

}
