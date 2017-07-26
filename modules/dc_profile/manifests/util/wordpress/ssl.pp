# Class dc_profile::util::wordpress::ssl
#
class dc_profile::util::wordpress::ssl {
  letsencrypt::certonly { 'www.datacentred.co.uk':
    domains              => [
      'www.datacentred.co.uk',
      'www.datacentred.io',
      'www.datacentred.net',
      'www.datacentred.com',
      'www.datacentred.org',
      'www.datacentred.org.uk',
      'datacentred.co.uk',
      'datacentred.io',
      'datacentred.net',
      'datacentred.com',
      'datacentred.org',
      'datacentred.org.uk',
    ],
    manage_cron          => true,
    cron_before_command  => '/bin/systemctl stop nginx.service',
    cron_success_command => '/bin/systemctl start nginx.service',
  }
}
