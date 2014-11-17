# == Class: dc_mcollective::install
#
class dc_mcollective::install {

  include ::mcollective

  package { $dc_mcollective::plugins:
    ensure => latest,
  }

}
