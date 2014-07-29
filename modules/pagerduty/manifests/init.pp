class pagerduty {
  package { 'pdagent':
    ensure  => installed,
    require => Apt::Source['pagerduty'],
  }

  package { 'pdagent-integrations':
    ensure  => installed,
    require => Apt::Source['pagerduty'],
  }

  service { 'pdagent':
    ensure  => running,
    enable  => true,
    require => Package['pdagent'],
  }
}

