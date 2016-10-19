# == Class: dc_foreman
#
# DataCentred hacks to support The Foreskin
#
class dc_foreman (
  $encryption_key,
  $memcache_servers,
  $memcache_namespace = 'foreman',
  $memcache_compress = true,
  $memcache_expiry = 86400,
) {

  include ::dc_foreman::comms
  include ::dc_foreman::encryption_key
  include ::dc_foreman::memcache

}
