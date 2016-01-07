# Class: dc_openvas::load_target
#
# Loads an openvas target
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
define dc_openvas::load_target (
  $target,
) {

  include dc_openvas

  exec { "${name}_target":
    command => "omp -u ${::dc_openvas::gsa_user} -w ${::dc_openvas::gsa_password} --xml=\'<create_target><name>${name}</name><hosts>${target}</hosts></create_target>\'",
    unless  => "omp --get-targets -u ${::dc_openvas::gsa_user} -w ${::dc_openvas::gsa_password} | grep -w ${name}",
    require => Runonce['delete_admin'],
  } ->
  exec { "${name}_task":
    command => "/usr/local/bin/create_task.sh -u ${::dc_openvas::gsa_user} -p ${::dc_openvas::gsa_password} -c \'Full and fast\' -t ${name} -s \'Daily\'",
    unless  => "omp --get-tasks -u ${::dc_openvas::gsa_user} -w ${::dc_openvas::gsa_password} | grep -w ${name}",
    require => [ File['/usr/local/bin/create_task.sh'], Runonce['delete_admin'], Exec['openvas_daily_schedule'] ],
  }

}

