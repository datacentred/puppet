# == Class: dc_profile::net::duplicity_dns
#
# Backs up dns records to amazon S3 and Ceph
#
class dc_profile::net::duplicity_dns {

  dc_backup::dc_duplicity_job { "${::fqdn}_dns" :
    source_dir     => '/var/zonebackups',
    backup_content => 'dns',
  }
  #remove me once old hostname based scripts have been blatted
  dc_backup::dc_duplicity_job { "${::hostname}_dns" :
    source_dir     => '/var/zonebackups',
    backup_content => 'dns',
    cloud          => 'none',
  }

}