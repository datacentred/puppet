class profile::git {

  package { 'git':
    ensure => installed,
  }

}
