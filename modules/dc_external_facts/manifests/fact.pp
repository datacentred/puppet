# Define a unique fact on the agent which will be reported
# to the master as a global variable
define dc_external_facts::fact (
  $value = true,
) {

  file { "/etc/facter/facts.d/${title}.txt":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "${title}=${value}",
    require => Class['dc_external_facts::external_facts'],
  }

}
