# Class: dc_dns::dnszone
#
# Defines a DNS zone in BIND
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
define dc_dns::dnszone (
  $soa         = undef,
  $soaip       = undef,
  $nameservers = undef,
  $reverse     = false,
  $isslave     = false,
  $masters  = '',
) {

  if $isslave {
    dns::zone {$title:
      zonetype    => 'slave',
      masters     => $masters,
      nameservers => $nameservers
    }
  } else {
    dns::zone {$title:
      soa         => $soa,
      soaip       => $soaip,
      nameservers => $nameservers,
      reverse     => $reverse,
    }
    # Create a backup definition
    dc_dnsbackup::backupzone { "${title}_${::hostname}":
      zonename => $title,
      master   => $::fqdn,
    }
  }

}
