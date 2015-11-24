# == Class: dc_icinga2::host
#
# Exports a generic host model for all machines.  By default, as is the
# common case the host is a satellite host, checked via the cluster-zone
# command on the parent
#
class dc_icinga2::host (
  $import = 'satellite-host',
  $display_name = $::fqdn,
  $address = $::ipaddress,
  $zone = undef,
  $icon_image = undef,
) {

  $_vars_common = {
    'architecture'     => $::architecture,
    'lsbdistcodename'  => $::lsbdistcodename,
    'operatingsystem'  => $::operatingsystem,
    'os'               => $::kernel,
    'role'             => $::role,
    'enable_pagerduty' => true,
  }

  if $::ipmi_ipaddress {
    $_vars_bmc = {
      'address_bmc' => $::ipmi_ipaddress,
    }
  }

  $_vars = merge($_vars_common, $_vars_bmc)

  @@icinga2::object::host { $::fqdn:
    import       => $import,
    display_name => $display_name,
    address      => $address,
    vars         => $_vars,
    zone         => $zone,
    icon_image   => $icon_image,
    target       => "/etc/icinga2/zones.d/${::fqdn}/hosts.conf",
  }

}
