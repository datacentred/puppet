# Install rsyslog from local mirror
class dc_rsyslog::install {
  # Initialise the rsyslog mirror
  package { 'rsyslog':
    ensure  => '7.4.8-0adiscon1',
  }
}
