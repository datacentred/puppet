# == Define: dpkg::foreign_architecture
#
define dpkg::foreign_architecture (
  $ensure = present,
) {

  if $ensure == present {
    exec { "dpkg --add-architecture ${name}":
      unless => "dpkg --print-foreign-architectures | grep -q ${name}",
    }
  } else {
    exec { "dpkg --remove-architecture ${name}":
      onlyif => "dpkg --print-foreign-architectures | grep -q ${name}",
    }
  }

}
