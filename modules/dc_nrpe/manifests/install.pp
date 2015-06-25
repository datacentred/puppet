# == Class: dc_nrpe::install
#
class dc_nrpe::install {

  $nrpe_agent = $::operatingsystem ? {
    /(RedHat|CentOS)/ => 'nrpe',
    /(Debian|Ubuntu)/ => 'nagios-nrpe-server',
  }

  ensure_packages($nrpe_agent, {'alias' => 'nrpe-agent'})
  ensure_packages('python-netifaces')

}
