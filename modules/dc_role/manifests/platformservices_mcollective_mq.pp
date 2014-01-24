#
class dc_role::platformservices_mcollective_mq {

  anchor { 'dc_role::platformservices_mcollective_mq::first' } ->
  class { 'dc_profile::mcollective_mq': } ->
  anchor { 'dc_role::platformservices_mcollective_mq::last' }

}
