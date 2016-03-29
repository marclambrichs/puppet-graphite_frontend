#
class graphite_web::install {

  if $::graphite_web::manage_packages {
    create_resources('package', {
      'django' => {
        ensure => $graphite_web::gw_django_version,
        name   => $graphite_web::gw_django_pkg
      },
      'django-tagging' => {
        ensure => $graphite_web::gw_django_tagging_version,
        name   => $graphite_web::gw_django_tagging_pkg
      },
      'graphite-web' => {
        ensure => $graphite_web::gw_graphite_web_version,
        name   => $graphite_web::gw_graphite_web_pkg
      },
      'mod_wsgi' => {
        ensure => $graphite_web::gw_mod_wsgi_version,
        name   => $graphite_web::gw_mod_wsgi_pkg
      },
      'pycairo' => {
        ensure => $graphite_web::gw_pycairo_version,
        name   => $graphite_web::gw_pycairo_pkg
      },
      'pytz' => {
        ensure => $graphite_web::gw_pytz_version,
        name   => $graphite_web::gw_pytz_pkg
      }
    })
  }

  exec { 'init django db':
    command     => '/bin/python manage.py syncdb --noinput',
    creates     => '/var/lib/graphite-web/graphite.db',
    path        => '/usr/lib/python2.7/site-packages',
    refreshonly => true,
    require     => File["${graphite_web::gw_webapp_dir}/local_settings.py"]
  }

}
