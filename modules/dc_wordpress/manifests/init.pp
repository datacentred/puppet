# Class: dc_wordpress
#
# Setup a wordpress installation (A LEMP stack without the wordpress files)
#
# Note: At this time, you need to put the wordpress files yourself on the
#       host in the /var/www/<website_directory>
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_wordpress (
  $wordpress_vhost        = undef,
  $wordpress_server_names = [],
  $wordpress_db_user      = undef,
  $wordpress_db_pass      = undef,
  $wordpress_db_host      = undef,
  $wordpress_db_name      = undef,
) {

  if ($wordpress_vhost == undef) {
    fail('No virtual host specified for the wordpress server.')
  }
  if ($wordpress_server_names == []) {
    fail('No server names specified for the wordpress virtual host.')
  }
  if ($wordpress_db_user == undef) {
    fail('No database user specified.')
  }
  if ($wordpress_db_pass == undef) {
    fail('No database password specified.')
  }
  if ($wordpress_db_name == undef) {
    fail('No database name specified.')
  }
  if ($wordpress_db_name == undef) {
    fail('No database host specified.')
  }

  class { 'dc_wordpress::server':
    vhost       => $wordpress_vhost,
    server_name => $wordpress_server_names,
  } ->
  class { 'dc_wordpress::php': } ->
  class { 'dc_wordpress::database':
    db_user => $wordpress_db_user,
    db_pass => $wordpress_db_pass,
    db_host => $wordpress_db_host,
    db_name => $wordpress_db_name,
  }
}
