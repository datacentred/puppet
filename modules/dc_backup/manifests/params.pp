# == Class: dc_backup::params
#
# Pulls in all the bits of data we need from hiera
#
class dc_backup::params (
$datacentred_swift_id,
$datacentred_swift_key,
$datacentred_swift_access_point,
$swift_authversion,
$datacentred_amazon_s3_id,
$datacentred_amazon_s3_key,
) {
}