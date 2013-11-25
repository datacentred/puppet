# Install git so we can get our repository
class dc_puppetmaster::git::install {

  package { 'git':
    ensure  => present,
  }

}
