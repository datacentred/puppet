# Install rsyslog from local mirror
class dc_rsyslog::install {
  # Initialise the rsyslog mirror
  package { 'rsyslog':
    ensure  => latest,
  }
}
