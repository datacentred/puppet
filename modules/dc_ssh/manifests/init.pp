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

  # ********************************************************************
  # IMPORTANT SECURITY INFORMATION
  # ********************************************************************
  # Bootstrapping staging requires password root login via SSH
  # if this fact is set then allow a relaxed configuration.  Once
  # bootstrapping is complete hosts configured like this will
  # converge to the default security settings.  Root login MUST
  # be via an in-memory one time password to minimise the risks
  # to an absolute minimum.
  # ********************************************************************

  if $::staging_bootstrap {
    $_bootstrap_configuration = {
      'PermitRootLogin'        => {
        'value' => 'yes',
      },
      'PasswordAuthentication' => {
        'value' => 'yes',
      },
      # Public key will be tried first, so we need at least 2 tries when
      # logging in manually for debugging purposes
      'MaxAuthTries'           => {
        'value' => '2',
      },
      # stdlib's deep_merge doesn't cater for array merging so just disable
      # this option for now
      'AllowGroups'            => {
        'ensure' => 'absent',
      },
    }
  } else {
    $_bootstrap_configuration = {}
  }

  $_merged_config = hiera_hash(dc_ssh::config)
  $merged_config = merge($_merged_config, $_bootstrap_configuration)

  create_resources('sshd_config', $merged_config)

  service { 'ssh':
    ensure     => true,
    enable     => true,
    hasrestart => true,
    name       => $dc_ssh::params::service_name,
  }

  Sshd_config <||> ~> Service['ssh']

}
