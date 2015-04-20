# == Class: dc_backup::params
#
# Pulls in all the bits of data we need from hiera
#
class dc_backup::params (
$datacentred_ceph_access_key,
$datacentred_ceph_secret_key,
$datacentred_ceph_access_point,
$datacentred_amazon_s3_id,
$datacentred_amazon_s3_key,
$datacentred_signing_key_short_id,
$datacentred_encryption_key_short_id,
$datacentred_private_signing_key_password,
$datacentred_private_encryption_key_password,
) {
}