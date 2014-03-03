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
  $reverse     = undef,
  $isslave     = false
) {

  if $isslave {
    dns::zone {$title:
      zonetype    => 'slave',
      masters     => hiera(dnsmasters),
      nameservers => $nameservers
    }
  } else {
    dns::zone {$title:
      soa         => $soa,
      soaip       => $soaip,
      nameservers => $nameservers,
      reverse     => $reverse,
    }
    # Export a backup definition
    @@dc_dnsbackup::backupzone { "${title}_${::hostname}":
      zonename => $title,
      master   => $::fqdn,
    }
  }

}
