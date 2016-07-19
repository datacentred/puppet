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
