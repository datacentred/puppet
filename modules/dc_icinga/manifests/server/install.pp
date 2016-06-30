# Class:
#
# Installs icinga for Ubuntu 12.04 and the legacy web interface
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_icinga::server::install {

  $packages = [
    'python-tftpy',
    'nfs-common',
    'libwww-perl',
    'libjson-perl',
    'libnagios-plugin-perl',
    'curl',
    'bc',
    'postgresql-client',
    'python-pymongo',
    'python-psycopg2',
    'libcache-memcached-perl',
  ]

  ensure_packages($packages)

  # Fix the RPC check, easiest way is to symlink
  file { '/usr/bin/rpcinfo':
    ensure  => link,
    target  => '/usr/sbin/rpcinfo',
    require => Package['nfs-common'],
  }

  # Need latest pip packages for some checks
  $pip_packages = [ 'nagios-plugin-elasticsearch',
                    'python-neutronclient',
                    'python-ceilometerclient',
                    'python-cinderclient',
                    'python-novaclient',
                    'python-keystoneclient',
                    'ndg-httpsclient',
                    'pyasn1' ]

  ensure_packages($pip_packages, {'ensure' => 'latest', 'provider' => 'pip'})

}
