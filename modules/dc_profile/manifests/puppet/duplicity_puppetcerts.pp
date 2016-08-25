# == Class: dc_profile::puppet::duplicity_puppetcerts
#
# Backs up puppetcerts to amazon S3 and Ceph
#
class dc_profile::puppet::duplicity_puppetcerts {

  if versioncmp($::puppetversion, '4.0.0') >= 0 {
    $_ssldir = '/etc/puppetlabs/puppet/ssl'
  } else {
    $_ssldir = '/var/lib/puppet/ssl'
  }

  dc_backup::dc_duplicity_job { "${::fqdn}_puppetcerts" :
    source_dir     => $_ssldir,
    backup_content => 'puppetcerts',
  }

}
