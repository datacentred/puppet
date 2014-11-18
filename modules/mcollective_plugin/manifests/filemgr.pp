# == Class: mcollective_plugin::filemgr
#
class mcollective_plugin::filemgr {

  package { 'mcollective-filemgr-agent':
    ensure => installed,
  }

}
