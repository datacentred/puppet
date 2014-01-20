# Class to handle the installation of the NSCA client
class dc_nsca::client {

  package {'nsca-client':
    ensure => installed,
  }

}

