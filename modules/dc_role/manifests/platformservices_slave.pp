# Class: dc_role::platformservices_slave
#
# Slave DNS/DHCP/TFTP server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::platformservices_slave {

  contain dc_profile::net::dns_slave
  contain dc_profile::net::dhcpd_slave
  contain dc_profile::net::tftpserver

}
