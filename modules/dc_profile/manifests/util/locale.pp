# Class: dc_profile::util::locale
#
# Make sure the locale is set correctly
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::util::locale {

  $locale = "LANG=\"en_GB.utf8\"
LANGUAGE=\"en_GB.utf8\"\n"

  file {'/etc/default/locale':
    ensure  => file,
    content => $locale,
  }

}
