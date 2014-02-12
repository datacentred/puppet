#
class dc_puppet::agent::config {

  # If we are explicitly a puppet master user ourself
  # otherwise go via the ENC
  if $::puppetmaster_stage {
    $server = $::fqdn
  } else {
    $server = $::puppetmaster
  }

  concat_fragment { 'puppet.conf+20-agent':
    content => template('dc_puppet/agent/puppet.conf-agent.erb'),
  }
}
