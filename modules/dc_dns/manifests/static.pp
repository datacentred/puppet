# == Class: dc_dns::static
#
# Static configuration
#
class dc_dns::static {

  # TODO: Delete me
  Dns_resource <<||>>

  $records = hiera_hash('dc_dns::static::records')

  # Create DNS records from a hash stored in Hiera
  # for anything 'static' we require
  create_resources(dns_resource, $records)

  # Ensure DNS (e.g. the zones and rndc) are installed before
  # attempting to inject static DNS resources
  Class['::dc_dns'] -> Class['::dc_dns::static']

}
