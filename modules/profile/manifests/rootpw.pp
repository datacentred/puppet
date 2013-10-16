class profile::rootpw {

  $rpass = hiera('rpass')

  user { 'root':
    ensure => present,
    password => "$rpass",
  }

}
