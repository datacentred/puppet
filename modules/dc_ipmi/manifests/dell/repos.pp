# Heavily influenced by https://github.com/newrelic/puppet-dell

class dc_ipmi::dell::repos {
  # Dell APT Repos
  apt::key { 'dell-community':
    key        => '1285491434D8786F',
    key_server => 'pool.sks-keyservers.net',
  }

  apt::source { 'dell-community':
    location          => 'http://linux.dell.com/repo/community/debian',
    release           => $::lsbdistcodename,
    repos             => 'openmanage',
    include_src       => false,
  }
}