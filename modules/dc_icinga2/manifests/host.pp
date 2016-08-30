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
    'architecture'      => $::architecture,
    'domain'            => $::domain,
    'enable_pagerduty'  => true,
    'hostname'          => $::hostname,
    'is_virtual'        => str2bool($::is_virtual),
    'kernel'            => $::kernel,
    'lsbdistcodename'   => $::lsbdistcodename,
    'operatingsystem'   => $::operatingsystem,
    'primary_interface' => icinga2_foreman_primary_interface(),
    'productname'       => $::productname,
    'role'              => $::role,
  }

  $_vars_blockdevices = icinga2_blockdevices()
  $_vars_interfaces = icinga2_interfaces()
  $_vars_foreman_interfaces = icinga2_foreman_interfaces()

  if $::ipmi_ipaddress {
    $_vars_bmc = {
      'address_bmc' => $::ipmi_ipaddress,
    }
  }

  $_vars = merge($_vars_common, $_vars_blockdevices, $_vars_interfaces, $_vars_foreman_interfaces, $_vars_bmc)

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
