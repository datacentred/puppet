# Class: dc_tftp::icinga
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_tftp::icinga {

  Class['dc_tftp::configure'] ->

  file { "${::dc_tftp::tftp_dir}/nagios_test_file" :
    ensure  => file,
    owner   => $dc_tftp::tftp_user,
    group   => $dc_tftp::tftp_group,
    mode    => '0644',
    content => 'This is a test file',
  }

  include dc_icinga::hostgroup_tftp

}
