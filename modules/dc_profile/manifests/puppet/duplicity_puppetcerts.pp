# == Class: dc_profile::puppet::duplicity_puppetcerts
#
# Backs up puppetcerts to amazon S3 and Ceph
#
class dc_profile::puppet::duplicity_puppetcerts {

  dc_backup::dc_duplicity_job { "${::fqdn}_puppetcerts" :
    source_dir     => '/var/lib/puppet/ssl',
    backup_content => 'puppetcerts',
  }
  #remove me once old hostname based scripts have been blatted
  dc_backup::dc_duplicity_job { "${::hostname}_puppetcerts" :
    source_dir     => '/var/lib/puppet/ssl',
    backup_content => 'puppetcerts',
    cloud          => 'none',
  }

}