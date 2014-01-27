# Install rsyslog from local mirror
class dc_rsyslog::install {
  package { 'rsyslog':
    ensure  => latest,
  }
}
