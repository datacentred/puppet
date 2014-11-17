# == Class: dc_profile::puppet::mcollective
#
class dc_profile::puppet::mcollective {

  include ::mcollective

  mcollective::server::setting { 'registration':
    value => 'agentlist',
  }

  mcollective::server::setting { 'registerinterval':
    value => 900,
  }

  include ::mcollective_plugin::apt
  include ::mcollective_plugin::filemgr
  include ::mcollective_plugin::iptables
  include ::mcollective_plugin::nettest
  include ::mcollective_plugin::nrpe
  include ::mcollective_plugin::package
  include ::mcollective_plugin::puppet
  include ::mcollective_plugin::service
  include ::mcollective_plugin::shell

}
