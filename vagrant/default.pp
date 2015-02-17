# Define a global $PATH
Exec {
  path => [
    '/bin/',
    '/sbin/',
    '/usr/bin/',
    '/usr/sbin/',
  ],
}

# If we're running in Vagrant and a role is defined, include it.
if $::is_vagrant and $::vagrant_role {
  include $::vagrant_role
}
