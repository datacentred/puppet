# == Class: ceph_billing
#
# Quick dirty ceph_billing deployment script
#
class ceph_billing (
  $version,
  $project,
  $path,
  $source,
  $deploy_key,
  $db,
  $db_username,
  $db_password,
) {

  include ::ceph_billing::install
  include ::ceph_billing::configure

  Class['::ceph_billing::install'] ->
  Class['::ceph_billing::configure']

}
