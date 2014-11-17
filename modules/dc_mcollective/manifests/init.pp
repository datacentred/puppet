# == Class: dc_mcollective
#
class dc_mcollective (
  $plugins = [],
) {

  include ::dc_mcollective::install
  include ::dc_mcollective::configure

  Class['dc_mcollective::install'] ->
  Class['dc_mcollective::configure']

}
