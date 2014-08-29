# == Class: dc_puppet::params
#
# Puppet parameters
#
# === Parameters
#
# [*version*]
#   Version of puppet master and agent packages to install
#
# [*puppetdb_version*]
#   Version of puppetdb we are running
#
# [*puppetdb_url*]
#   FQDN of the puppetdb server
#
class dc_puppet::params (
  $version = 'latest',
  $puppetdb_version,
  $puppetdb_url,
) {

  # Puppet configuration directory
  $dir                  = '/etc/puppet'

  # Puppet variable data directory
  $vardir               = '/var/lib/puppet'

  # Puppet SSL certificate directory
  $ssldir               = "${vardir}/ssl"

  # Puppet envionments directory
  $envdir               = "${dir}/environments"

  # Puppet library directory
  $libdir               = '/usr/lib/ruby/vendor_ruby/puppet'

  # Puppet master package to install
  $master_package       = 'puppetmaster'

  # Puppet master service to refresh
  $master_service       = 'apache2'

  # Puppet agent package to install
  $agent_package        = 'puppet'

  # Whether to synchronise facter plugins to agents
  $pluginsync           = 'true'

  # Port to listen on
  $masterport           = '8140'

  # Default environement to use
  $environment          = 'production'

  # Whether the agent listens for kick requests (deprecated, uses mcollective)
  $listen               = 'false'

  # Whether the agent adds a random delay (not used, run by cron)
  $splay                = 'false'

  # How often to run the agent (not used, run by cron)
  $runinterval          = '1800'

  # Whether the agent applies the changes or not
  $noop                 = 'false'

  # Whether the agent shows differences between runs
  $show_diff            = 'true'

  # How long to wait for the catalogue before failing
  $configtimeout        = '240'

  # Which reports plugin to use
  $reports              = 'foreman'

  # Where the ENC script resides
  $external_nodes       = "${dir}/node.rb"

  # Which store configs backend to use
  $storeconfigs_backend = 'puppetdb'

  # Where foreman lives
  # TODO: unhack me
  $foreman_url          = "https://foreman-2.${::domain}"

  # Whether to use directory environments
  $directory_environments = true

}
