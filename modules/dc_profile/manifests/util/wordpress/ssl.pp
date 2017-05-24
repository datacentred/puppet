# Class dc_profile::util::wordpress::ssl
#
class dc_profile::util::wordpress::ssl {
  letsencrypt::certonly { 'www.datacentred.co.uk':
    manage_cron          => true,
    cron_before_command  => '/bin/systemctl stop nginx.service',
    cron_success_command => '/bin/systemctl start nginx.service',
  }
}
