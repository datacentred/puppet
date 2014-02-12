# Install git so we can get our repository
class dc_puppet::master::git::install {

  package { 'git':
    ensure  => present,
  }

}
