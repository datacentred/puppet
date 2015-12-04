# Class dc_foreman::python_lib
# Deploys our foreman python libraries
class dc_foreman::python_lib {

  file { '/usr/local/lib/python2.7/dist-packages/dc_foreman.py':
    ensure => file,
    source => 'puppet:///modules/dc_foreman/dc_foreman.py'
  }

}
