# Class: dc_role::bigyellow
#
# Bit of a mish mash this server!
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::bigyellow {

  contain dc_profile::db::pgbackup
  contain dc_profile::img::packer
  contain dc_profile::net::aptmirror
  contain dc_profile::net::nfsserver
  contain dc_profile::net::ponies
  contain dc_profile::net::tftpserver

}
