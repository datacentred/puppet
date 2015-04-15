# Class dc_foreman::service_checks
class dc_foreman::service_checks (
  $foreman_url,
  $foreman_admin_pw,
  $foreman_admin_user,
  $omapi_key,
  $omapi_secret,
  $omapi_port,
  $tftp_dir,
){

  file { '/usr/local/bin/foreman_check.py':
    ensure  => file,
    content => template('dc_foreman/foreman_check.py.erb'),
  }

}
