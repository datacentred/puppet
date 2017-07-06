# == Class: ::dc_netbox::backup
#
# go to below address for instruction how to use duplicity
# https://datacentred.atlassian.net/wiki/display/~bartosz.miklaszewski/BM+-+Duplicity+-+Recovery

class dc_netbox::backup (
  Hash $config,
){

  include ::dc_backup

  create_resources('dc_backup::dc_duplicity_job', $config)

}
