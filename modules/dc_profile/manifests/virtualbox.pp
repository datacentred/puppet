class dc_profile::virtualbox {

  include dc_profile::virtualboxrepo

  package { 'virtualbox-4.3' :
    ensure => installed, require => Dc_repos::Virtual::Repo['local_virtualbox_mirror']
  }

}
