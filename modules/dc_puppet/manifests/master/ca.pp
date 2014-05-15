class dc_puppet::master::ca {

  include ::dc_puppet::params

  $ssldir         = $dc_puppet::params::ssldir

  exec { 'create_certs':
    command => "puppet cert --generate ${::fqdn}",
    unless  => "ls ${ssldir}/certs/${::fqdn}.pem",
    path    => "/bin:/usr/bin",
  }

}
