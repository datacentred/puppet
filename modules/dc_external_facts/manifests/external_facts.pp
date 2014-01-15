# Prepares the host for generation of external facts
class dc_external_facts::external_facts {

  # Defaults to save duplication
  File {
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Create the directory structure, and remove unmanaged files
  file { '/etc/facter':
  } ->
  file { '/etc/facter/facts.d':
    recurse => true,
    purge   => true,
  }

}
