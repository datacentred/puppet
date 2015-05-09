# Class: dc_interop
#
# Quick and dirty module to install the OpenStack Refstack client with Tempest
# For the purposes of interopability testing.
#
# This module requires two existing projects and associated accounts that need
# to exist in the OpenStack instance you're looking to test.
#
# Parameters:
#   $username: First test account username
#   $password: First test account's password
#   $tenant_name: First project
#   $alt_username: Second test account username
#   $alt_password: Second test account's password
#   $alt_tenant_name: Second project
#   $region: Region
#   $image_ref: UUID of the image used to test
#   $flavor_ref:  Flavor UUID #1
#                 NB: It's recommended to use flavors with very small (<=1GB)
#                 root disks, otherwise some of the snapshot tests will timeout
#   $flavor_ref_alt: Flavor UUID #2
#   $dashboard_url: URL to Horizon
#   $identity_uri: Identity API endpoint V2
#   $client_home: Where to install the refstack client
#
# Actions: See above
#
# Requires: Vcsrepo, two pre-existing accounts and tenants in OpenStack
#
# Sample Usage:
#
class dc_interop (
  $username,
  $tenant_name,
  $password,
  $alt_username,
  $alt_tenant_name,
  $alt_password,
  $image_ref,
  $image_ref_alt,
  $flavor_ref,
  $flavor_ref_alt,
  $dashboard_url,
  $identity_uri,
  $refcore_tests,
  $region = sal01,
  $client_home = '/var/lib/refstack-client'
) {
  $packages = [ 'python-keystoneclient', 'python-novaclient',
                'python-neutronclient', 'python-cinderclient',
                'python-glanceclient', 'git', 'vim' ]

  ensure_packages($packages)

  vcsrepo { $client_home:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/stackforge/refstack-client',
    require  => Package['git'],
  }

  exec { 'setup_tempest':
    command => "${client_home}/setup_env",
    cwd     => $client_home,
    creates => "${client_home}/.tempest",
    require => Vcsrepo[$client_home],
  }

  exec { 'download_tests':
    command => "curl -sO ${refcore_tests}",
    cwd     => "${client_home}/.tempest/",
    require => Exec['setup_tempest'],
  }

  file { 'tempest.conf':
    path    => "${client_home}/.tempest/etc/tempest.conf",
    content => template('dc_interop/tempest.conf.erb'),
    require => Exec['setup_tempest'],
  }

}
