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

}
