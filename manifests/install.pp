# == Class graphite_frontend::install
#
#
class graphite_frontend::install {

  if $::graphite_frontend::manage_packages {
    create_resources('package', {
      'django' => {
        ensure => $graphite_frontend::gw_django_version,
        name   => $graphite_frontend::gw_django_pkg
      },
      'django-tagging' => {
        ensure => $graphite_frontend::gw_django_tagging_version,
        name   => $graphite_frontend::gw_django_tagging_pkg
      },
      'graphite-web' => {
        ensure => $graphite_frontend::gw_graphite_web_version,
        name   => $graphite_frontend::gw_graphite_web_pkg
      },
      'mod_wsgi' => {
        ensure => $graphite_frontend::gw_mod_wsgi_version,
        name   => $graphite_frontend::gw_mod_wsgi_pkg
      },
      'pycairo' => {
        ensure => $graphite_frontend::gw_pycairo_version,
        name   => $graphite_frontend::gw_pycairo_pkg
      },
      'pytz' => {
        ensure => $graphite_frontend::gw_pytz_version,
        name   => $graphite_frontend::gw_pytz_pkg
      }
    })

    if $::graphite_frontend::memcached_enabled {
      package { $graphite_frontend::gw_python_memcached_pkg:
        ensure => $graphite_frontend::gw_python_memcached_version
      }
    }
  }
}
