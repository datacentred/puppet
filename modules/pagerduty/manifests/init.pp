class pagerduty {
  apt::source { 'pagerduty':
    location    => 'http://packages.pagerduty.com/pdagent deb/',
    repos       => '',
    release     => '',
    include_src => false,
    key         => '9E65C6CB',
    key_source  => 'http://packages.pagerduty.com/GPG-KEY-pagerduty',
  }

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

