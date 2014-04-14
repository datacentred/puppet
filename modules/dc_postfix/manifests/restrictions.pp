class dc_postfix::restrictions {

  $external_sysmail_split = split(hiera(external_sysmail_address), '@')
  $external_mail_domain   = $external_sysmail_split[1]

  postfix::config { 'relay_domains':
    value => $external_mail_domain
  }

  # HELO restrictions
  postfix::config { 'smtpd_delay_reject':
    value => 'yes',
  }
  postfix::config { 'smtpd_helo_required':
    value => 'yes',
  }
  postfix::config { 'smtpd_helo_restrictions':
    value => 'permit_mynetworks, reject_non_fqdn_helo_hostname, reject_invalid_helo_hostname, permit'
  }

  # Recipient restrictions
  postfix::config { 'smtpd_recipient_restrictions':
    value => 'reject_unauth_pipelining, reject_non_fqdn_recipient, reject_unknown_recipient_domain, permit_mynetworks, reject_unauth_destination, permit'
  }

  # Sender restrictions
  postfix::config { 'smtpd_sender_restrictions':
    value => 'permit_mynetworks, reject_non_fqdn_sender, reject_unknown_sender_domain, permit'
  }

}

