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

  apache::vhost { $::fqdn:
    vhost_name      => '*',
    port            => '80',
    serveraliases   => [ 'graphite2.arthurjames.vagrant' ],
    docroot         => '/usr/share/graphite/webapp',
    error_log       => true,
    error_log_file  => "${::hostname}.error.log",
    redirect_dest   => "https://${::fqdn}/",
    redirect_status => 'permanent',
    access_logs     => [ {
      file  => "/var/log/httpd/${hostname}.access.log",
      ## unnecessary for now, but we need to change this
      format => 'combined'
    },],
    directories     => [ {
      provider => 'location',
      path     => '/server-status',
      sethandler => 'server-status',
      require    => 'ip 127.0.0.1',
#      order      => 'deny,allow',
#      deny       => 'from all',
#      allow      => 'from 127.0.0.1',
    },]
  }
}
