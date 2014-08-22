# Class: dc_nrpe::install
#
# Installs nagios nrpe server package
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
class dc_nrpe::install
{
  package { 'nagios-nrpe-server':
    ensure  => installed,
  }
}
