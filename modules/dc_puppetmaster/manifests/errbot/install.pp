# comment
class dc_puppetmaster::errbot::install {

  package { 'python-pip':
    ensure => installed,
  } ->
  exec { 'errbot_pip_install':
    path    => '/usr/bin',
    command => 'pip install err sleekxmpp pyasn1 pyasn1_modules',
  }

}
