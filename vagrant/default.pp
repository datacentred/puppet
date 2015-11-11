# Define a global $PATH
Exec {
  path => [
    '/bin/',
    '/sbin/',
    '/usr/bin/',
    '/usr/sbin/',
  ],
}

$classes = hiera_array('classes')
$excludes = hiera_array('excludes', [])
$includes = delete($classes, $excludes)
include $includes

# If we're running in Vagrant and a role is defined, include it.
if $::is_vagrant and $::vagrant_role {
  include $::vagrant_role
}
