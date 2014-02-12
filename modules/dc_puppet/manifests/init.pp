# One size fits all puppet class
class dc_puppet {

  # All hosts get the agent installed
  contain dc_puppet::agent
  contain dc_puppet::config

  # This is an external fact used to make a node
  # a puppet master.  You have to *manually* specify it
  # in /etc/facter/facts.d as it's the only way we can
  # have this work with both 'puppet apply' and via the
  # ENC
  if $::puppetmaster_stage {
    contain dc_puppet::master
  }

}
