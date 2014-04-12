class dc_postfix::ratelimit {

  postfix::config { 'default_destination_rate_delay':
    value => '3s',
  }
  postfix::config { 'default_destination_concurrency_limit':
    value => '10',
  }
  postfix::config { 'default_destination_recipient_limit':
    value => '2',
  }

}
