# == Class: ::dc_tidy
#
# Wrapper to the tidy function
#
define dc_tidy (
  $path = $title,
  $age = '1w',
  $backup = false,
  $matches = undef,
  $recurse = undef,
  $rmdirs = undef,
  $size = undef,
  $type = 'atime',
) {

  validate_absolute_path($path)
  validate_string($age)
  validate_bool($backup)
  validate_string($type)

  tidy { $path:
    age     => $age,
    backup  => $backup,
    matches => $matches,
    recurse => $recurse,
    rmdirs  => $rmdirs,
    size    => $size,
    type    => $type,
  }
}
