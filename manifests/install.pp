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

    if $::graphite_web::memcached_enabled {
      package { $graphite_web::gw_python_memcached_pkg:
        ensure => $graphite_web::gw_python_memcached_version
      }
    }
  }
}
