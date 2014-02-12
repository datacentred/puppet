#
class dc_puppet::params {
  $version              = 'latest'
  $dir                  = '/etc/puppet'
  $vardir               = '/var/lib/puppet'
  $ssldir               = "${vardir}/ssl"
  $envdir               = "${dir}/environments"
  $libdir               = '/usr/lib/ruby/vendor_ruby/puppet'
  $master_package       = 'puppetmaster-passenger'
  $master_service       = 'apache2'
  $agent_package        = 'puppet'

  $pluginsync           = 'true'
  $masterport           = '8140'
  $environment          = 'production'
  $listen               = 'false'
  $splay                = 'false'
  $runinterval          = '1800'
  $noop                 = 'false'
  $show_diff            = 'true'
  $configtimeout        = '120'

  $reports              = 'foreman'
  $external_nodes       = "${dir}/node.rb"
  $storeconfigs_backend = 'puppetdb'

  # TODO: hack
  $foreman_url          = 'foreman.sal01.datacentred.co.uk'
}
