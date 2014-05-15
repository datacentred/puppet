# Class: dc_puppet::master::passenger
#
# Puppet master passenger configuration
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::passenger {

  include ::dc_puppet::params

  include ::apache
  include ::apache::mod::passenger

  $approot = '/etc/puppet/rack'
  $docroot = "${approot}/public/"
  $ssldir  = $::dc_puppet::params::ssldir

  # puppet master packages are installed and the certs generated
  # create the rack application
  file { [ $approot, $docroot, "$approot/tmp" ]:
    ensure => directory,
    mode   => '0755',
  } ->

  # The permissions here are uber important as passenger will
  # nopt be remotely helpful
  file { "${approot}/config.ru":
    ensure => file,
    source => 'puppet:///modules/dc_puppet/master/config.ru',
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0644',
  } ->

  # Finally create the puppet master vhost once that is all
  # up and ready
  apache::vhost { 'puppetmaster':
    docroot           => $docroot,
    port              => '8140',
    ssl               => true,
    ssl_protocol      => '-ALL +SSLv3 +TLSv1',
    ssl_cipher        => 'ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:-LOW:-SSLv2:-EXP',
    ssl_cert          => "${ssldir}/certs/${::fqdn}.pem",
    ssl_key           => "${ssldir}/private_keys/${::fqdn}.pem",
    ssl_chain         => "${ssldir}/certs/ca.pem",
    ssl_ca            => "${ssldir}/certs/ca.pem",
    ssl_crl           => "${ssldir}/ca/ca_crl.pem",
    ssl_verify_client => 'optional',
    ssl_verify_depth  => '1',
    ssl_options       => '+StdEnvVars +ExportCertData',
    request_headers   => [
      'unset X-Forwarded-For',
      'set X-SSL-Subject %{SSL_CLIENT_S_DN}e',
      'set X-Client-DN %{SSL_CLIENT_S_DN}e',
      'set X-Client-Verify %{SSL_CLIENT_VERIFY}e',
    ],
    rack_base_uris    => '/',
    directories       => {
      path           => $docroot,
      options        => 'None',
      allow_override => 'None',
    },
  }

}
