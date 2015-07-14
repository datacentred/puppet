# == Class: dc_dashing::config
#
class dc_dashing::config(
  $data_provider_graphite_prefix,
  $graphite_url,
  $icinga_url,
  $icinga_auth_key,
  $pagerduty_subdomain,
  $pagerduty_api_token,
  $pagerduty_policy,
  $sirportly_url,
  $sirportly_api_token,
  $sirportly_secret_token,
  $dashing_dir_path,
) {
    file{ '/etc/init.d/dashing':
      ensure  => file,
      content => template('dc_dashing/init/dashing.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0755'
    }

    file{ '/opt/dashing/lib/':
      ensure => directory
    }

    file{ '/opt/dashing/lib/graphite.rb':
      ensure  => file,
      content => template('dc_dashing/lib/graphite.rb.erb'),
    }

    file{ '/opt/dashing/lib/icinga.rb':
      ensure  => file,
      content => template('dc_dashing/lib/icinga.rb.erb'),
    }

    file{ '/opt/dashing/lib/sirportly_client.rb':
      ensure  => file,
      content => template('dc_dashing/lib/sirportly_client.rb.erb'),
    }

    file{ '/opt/dashing/lib/pagerduty_client.rb':
      ensure  => file,
      content => template('dc_dashing/lib/pagerduty_client.rb.erb'),
    }

    file{ '/opt/dashing/lib/data_provider.rb':
      ensure  => file,
      content => template('dc_dashing/lib/data_provider.rb.erb'),
    }

    file{ '/opt/dashing/jobs/':
      ensure  => directory,
      source  => 'puppet:///modules/dc_dashing/jobs/',
      recurse => true,
      purge   => true,
    }

    file{ '/opt/dashing/dashboards/':
      ensure  => directory,
      source  => 'puppet:///modules/dc_dashing/dashboards/',
      recurse => true,
      purge   => true,
    }

    file{ '/opt/dashing/assets/':
      ensure  => directory,
      source  => 'puppet:///modules/dc_dashing/assets/',
      recurse => true,
    }

    file{ '/opt/dashing/widgets/':
      ensure  => directory,
      source  => 'puppet:///modules/dc_dashing/widgets/',
      recurse => true
    }

    bundler::install { '/opt/dashing/':
      user  => root,
      group => root
    }
}
