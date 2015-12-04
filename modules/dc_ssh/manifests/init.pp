# == Class: dc_ssh
#
# Generic SSH daemon configuration.  Locks out root login and
# limits access to specific user groups
#
# === Parameters
#
# [*config*]
#   Hash of sshd configuration commands passed down to the
#   augeas provider
#
# === Notes
#
# Typically the configuration is sourced from common.yaml for most machines,
# platform specific overrides are provided where necessary so grep for
# all affected configurations when adding new groups (e.g. vagrant needs
# to allow root login for vagrant ssh and provison commands to work post
# provisioning)
#
class dc_ssh {

  include dc_ssh::params

  $merged_config = hiera_hash(dc_ssh::config)

  create_resources('sshd_config', $merged_config)

  service { 'ssh':
    ensure     => true,
    enable     => true,
    hasrestart => true,
    name       => $dc_ssh::params::service_name,
  }

  Sshd_config <||> ~> Service['ssh']

}
