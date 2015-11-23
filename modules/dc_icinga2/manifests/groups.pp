# == Class: dc_icinga2::groups
#
# Define host and service groups
#
class dc_icinga2::groups {

  Icinga2::Object::Hostgroup {
    target => '/etc/icinga2/zones.d/global-templates/groups.conf',
  }

  # Host Groups

  icinga2::object::hostgroup { 'linux-servers':
    display_name => 'Linux Servers',
    assign_where => 'host.vars.kernel == "Linux"',
  }

  icinga2::object::hostgroup { 'ubuntu-servers':
    display_name => 'Ubuntu Servers',
    assign_where => 'host.vars.operatingsystem == "Ubuntu"',
  }

  icinga2::object::hostgroup { 'trusty-servers':
    display_name => 'Ubuntu Trusty (14.04) Servers',
    assign_where => 'host.vars.lsbdistcodename == "trusty"',
  }

  icinga2::object::hostgroup { 'utopic-servers':
    display_name => 'Ubuntu Utopic (14.10) Servers',
    assign_where => 'host.vars.lsbdistcodename == "utopic"',
  }

  icinga2::object::hostgroup { 'vivid-servers':
    display_name => 'Ubuntu Vivid (15.04) Servers',
    assign_where => 'host.vars.lsbdistcodename == "vivid"',
  }

  icinga2::object::hostgroup { 'redhat-servers':
    display_name => 'RedHat Servers',
    assign_where => 'host.vars.operatingsystem == "RedHat"',
  }

  icinga2::object::hostgroup { 'fedora-servers':
    display_name => 'Fedora Servers',
    assign_where => 'host.vars.operatingsystem == "Fedora"',
  }

  icinga2::object::hostgroup { 'centos-servers':
    display_name => 'Centos Servers',
    assign_where => 'host.vars.operatingsystem == "Centos"',
  }

  icinga2::object::hostgroup { 'aarch64-servers':
    display_name => 'Aarch64 Servers',
    assign_where => 'host.vars.architecture == "aarch64"',
  }

  icinga2::object::hostgroup { 'amd64-servers':
    display_name => 'Amd64 Servers',
    assign_where => 'host.vars.architecture == "amd64"',
  }

  # Service Groups

  icinga2::object::servicegroup { 'apt':
    display_name => 'Apt Checks',
    assign_where => 'match("apt", service.name)',
  }

  icinga2::object::servicegroup { 'bmc':
    display_name => 'BMC Checks',
    assign_where => 'match("bmc*", service.name)',
  }

  icinga2::object::servicegroup { 'disk':
    display_name => 'Disk Checks',
    assign_where => 'match("disk", service.name)',
  }

  icinga2::object::servicegroup { 'dns':
    display_name => 'DNS Checks',
    assign_where => 'match("dns", service.name)',
  }

  icinga2::object::servicegroup { 'jenkins':
    display_name => 'Jenkins Checks',
    assign_where => 'match("jenkins", service.name)',
  }

  icinga2::object::servicegroup { 'load':
    display_name => 'Load Checks',
    assign_where => 'match("load", service.name)',
  }

  icinga2::object::servicegroup { 'procs':
    display_name => 'Process Checks',
    assign_where => 'match("procs", service.name)',
  }

  icinga2::object::servicegroup { 'puppetdb':
    display_name => 'PuppetDB Checks',
    assign_where => 'match("puppetdb", service.name)',
  }

  icinga2::object::servicegroup { 'puppetserver':
    display_name => 'Puppet Server Checks',
    assign_where => 'match("puppetserver", service.name)',
  }

  icinga2::object::servicegroup { 'ssh':
    display_name => 'SSH Checks',
    assign_where => 'match("ssh", service.name)',
  }

  icinga2::object::servicegroup { 'swap':
    display_name => 'Swap Checks',
    assign_where => 'match("swap", service.name)',
  }

  icinga2::object::servicegroup { 'users':
    display_name => 'User Checks',
    assign_where => 'match("users", service.name)',
  }

}
