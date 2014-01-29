# Install a message queue for use my mcollective
class dc_role::platformservices_mco_mq {

  class { 'dc_profile::mcollective_mq': }
  contain 'dc_profile::mcollective_mq'

}
