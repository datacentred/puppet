# == Class: dc_icinga2_plugins::module
#
#
define dc_icinga2_plugins::module (
  Dc_icinga2_plugins::PluginList $plugins,
  Dc_icinga2_plugins::PackageList $packages = [],
  Dc_icinga2_plugins::PackageList $pip_packages = [],
) {

  # Install base directories
  include dc_icinga2_plugins::base

  # Install all plugins in the list
  $plugins.each |$plugin| {
    file { "/usr/local/lib/nagios/plugins/${plugin}":
      content => file("dc_icinga2_plugins/${plugin}"),
    }
  }

  ensure_packages($packages)

  # If we are installing any packages from pip, automatically install python-pip
  # and ensure its installed before proceeding with the pip packages
  if $pip_packages {
    ensure_packages('python-pip')

    ensure_packages($pip_packages, { 'provider' => 'pip' })

    Package['python-pip'] -> Package[$pip_packages]
  }

}
