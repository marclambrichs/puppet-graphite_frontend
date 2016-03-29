# == Class graphite_web::config
#
#
class graphite_web::config {

  file { "${graphite_web::gw_webapp_dir}/local_settings.py":
    ensure  => file,
    content => template('graphite_web/etc/graphite-web/local_settings.py.erb'),
    group   => $graphite_web::gw_group,
    mode    => '0644',
    owner   => $graphite_web::gw_user,
    require => Package[$graphite_web::gw_graphite_web_pkg]
  }

  file { "${graphite_web::gw_webapp_dir}/graphite.wsgi":
    ensure  => file,
    content => template('graphite_web/etc/graphite-web/graphite.wsgi.erb'),
    group   => $graphite_web::gw_group,
    mode    => '0644',
    owner   => $graphite_web::gw_user,
    require => Package[$graphite_web::gw_graphite_web_pkg]
  }

  file { "${graphite_web::gw_webapp_dir}/dashboard.conf":
    ensure  => file,
    content => template('graphite_web/etc/graphite-web/dashboard.conf.erb'),
    group   => $graphite_web::gw_group,
    mode    => '0644',
    owner   => $graphite_web::gw_user,
    require => Package[$graphite_web::gw_graphite_web_pkg]
  }

  exec { 'init django db':
    command     => '/bin/python ./manage.py syncdb --noinput',
    cwd         => '/usr/lib/python2.7/site-packages/graphite',
    refreshonly => true,
    require     => File["${graphite_web::gw_webapp_dir}/local_settings.py"]
  }

  class {'apache': }

  apache::vhost { $::hostname:
    vhost_name      => '*',
    port            => '80',
    serveraliases   => [ 'graphite2.arthurjames.vagrant' ],
    error_log       => true,
    error_log_file  => '/var/log/graphite-web/error.log',
    redirect_dest   => "https://${::hostname}/",
    redirect_status => 'permanent',
    custom_fragment => 'CustomLog "/var/log/graphite-web/access.log" combined_time',
    directories     => [
      {
        custom_fragment => '
    ## enable server-status for localhost (needed for collectd apache plugin)
    <Location /server-status>
        SetHandler server-status
        Order deny,allow
        Deny from all
        Allow from 127.0.0.1
    </Location>',
      },
    ]
  }

}
