# == Class: dc_dns::zone
#
# Wrapper for a DNS zone.  Performs backups on zones on DNS masters
#
define dc_dns::zone (
  $reverse = false,
  $masters = [],
) {

  dns::zone { $title:
    reverse => $reverse,
    masters => $masters,
  }

  # Create a backup definition
  if ! $masters {
    dc_dnsbackup::backupzone { "${title}_${::hostname}":
      zonename => $title,
      master   => $::fqdn,
    }
  }

}
