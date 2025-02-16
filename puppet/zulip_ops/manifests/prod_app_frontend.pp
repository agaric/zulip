class zulip_ops::prod_app_frontend {
  include zulip_ops::base
  include zulip_ops::app_frontend

  file { '/etc/nginx/sites-available/zulip':
    ensure  => file,
    require => Package['nginx-full'],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/zulip_ops/nginx/sites-available/zulip',
    notify  => Service['nginx'],
  }

  file { '/etc/nginx/sites-enabled/zulip':
    ensure  => 'link',
    require => Package['nginx-full'],
    target  => '/etc/nginx/sites-available/zulip',
    notify  => Service['nginx'],
  }

  file { '/usr/lib/nagios/plugins/zulip_zephyr_mirror':
    require => Package[nagios-plugins-basic],
    recurse => true,
    purge   => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/zulip_ops/nagios_plugins/zulip_zephyr_mirror',
  }

  # TODO: This should ideally move to a prod_app_frontend_once.pp
  file { '/etc/cron.d/update-first-visible-message-id':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/zulip/cron.d/calculate-first-visible-message-id',
  }

  # TODO: This should ideally move to a prod_app_frontend_once.pp
  file { '/etc/cron.d/invoice-plans':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/zulip/cron.d/invoice-plans',
  }

  # Prod has our Apple Push Notifications Service private key at
  # /etc/ssl/django-private/apns-dist.pem
}
