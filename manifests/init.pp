# == Class: graphite_web
#
# Installs, configures and manages graphite-web service.
#
# === Parameters
#
# [*apache_service_name*]
#   Default: 'httpd'
#
# [*gw_django_version*]
#
# [*gw_django_pkg*]
#
# [*gw_django_tagging_version*]
#
# [*gw_django_tagging_pkg*]
#
# [*gw_graphite_web_pkg*]
#   Specifies the name of the graphite web package.
#   Default: 'graphite-web'
#
# [*gw_graphite_web_version*]
#   Specifies the version of the graphite web package.
#   Default: present
#
# [*gw_mod_wsgi_version*]
#
# [*gw_mod_wsgi_pkg*]
#
# [*gw_pycairo_version*]
#
# [*gw_pycairo_pkg*]
#
# [*gw_pytz_version*]
#
# [*gw_pytz_pkg*]
#
# [*manage_packages*]
#   Specifies if this module should or should not install packages.
#   Type: Boolean
#   Default: true
#
# === Examples
#
#  class { 'graphite_web': }
#
#
# === Authors
#
# Marc Lambrichs <marc.lambrichs@gmail.com>
#
# === Copyright
#
# Copyright 2016 Marc Lambrichs
#
class graphite_web (
  $apache_service_name         = $graphite_web::params::apache_service_name,
  $ls_carbonlink_hosts         = $graphite_web::params::ls_carbonlink_hosts,
  $ls_carbonlink_timeout       = $graphite_web::params::ls_carbonlink_timeout,
  $ls_conf_dir                 = $graphite_web::params::ls_conf_dir,
  $ls_content_dir              = $graphite_web::params::ls_content_dir,
  $ls_db_name                  = $graphite_web::params::ls_db_name,
  $ls_db_engine                = $graphite_web::params::ls_db_engine,
  $ls_default_cache_duration   = $graphite_web::params::ls_default_cache_duration,
  $ls_graphite_root            = $graphite_web::params::ls_graphite_root,
  $ls_index_file               = $graphite_web::params::ls_index_file,
  $ls_log_dir                  = $graphite_web::params::ls_log_dir,
  $ls_memcached_hosts          = $graphite_web::params::ls_memcached_hosts,
  $ls_secret_key               = $graphite_web::params::ls_secret_key,
  $ls_storage_dir              = $graphite_web::params::ls_storage_dir,
  $ls_timezone                 = $graphite_web::params::ls_timezone,
  $ls_whisper_dir              = $graphite_web::params::ls_whisper_dir,
  $gw_django_version           = $graphite_web::params::gw_django_version,
  $gw_django_pkg               = $graphite_web::params::gw_django_pkg,
  $gw_django_tagging_version   = $graphite_web::params::gw_django_tagging_version,
  $gw_django_tagging_pkg       = $graphite_web::params::gw_django_tagging_pkg,
  $gw_graphite_web_version     = $graphite_web::params::gw_graphite_web_version,
  $gw_graphite_web_pkg         = $graphite_web::params::gw_graphite_web_pkg,
  $gw_mod_wsgi_version         = $graphite_web::params::gw_mod_wsgi_version,
  $gw_mod_wsgi_pkg             = $graphite_web::params::gw_mod_wsgi_pkg,
  $gw_pycairo_version          = $graphite_web::params::gw_pycairo_version,
  $gw_pycairo_pkg              = $graphite_web::params::gw_pycairo_pkg,
  $gw_python_memcached_pkg     = $graphite_web::params::gw_python_memcached_pkg,
  $gw_python_memcached_version = $graphite_web::params::gw_python_memcached_version,
  $gw_pytz_version             = $graphite_web::params::gw_pytz_version,
  $gw_pytz_pkg                 = $graphite_web::params::gw_pytz_pkg,
  $gw_webapp_dir               = $graphite_web::params::gw_webapp_dir,
  $manage_packages             = $graphite_web::params::manage_packages,
  $memcached_enabled           = $graphite_web::params::memcached_enabled,
  $vhosts                      = $graphite_web::params::vhosts,
) inherits graphite_web::params {

  validate_absolute_path( $gw_webapp_dir )

  validate_bool(
    $manage_packages,
    $memcached_enabled,
  )

  validate_hash( $ls_carbonlink_hosts )
  validate_hash( $vhosts )

  validate_numeric( $ls_carbonlink_timeout )

  validate_re( $gw_django_version, '^(present|\d+\.\d+\.\d+)$' )
  validate_re( $gw_django_tagging_version, '^(present|\d+\.\d+\.\d+)$' )
  validate_re( $gw_graphite_web_version, '^(present|\d+\.\d+\.\d+)$' )
  validate_re( $gw_mod_wsgi_version, '^(present|\d+\.\d+\.\d+)$' )
  validate_re( $gw_pycairo_version, '^(present|\d+\.\d+\.\d+)$' )
  validate_re( $gw_python_memcached_version, '^(present|\d+\.\d+\.\d+)$' )
  validate_re( $gw_pytz_version, '^(present|\d+\.\d+\.\d+)$' )

  validate_string(
    $apache_service_name,
    $gw_django_pkg,
    $gw_django_tagging_pkg,
    $gw_graphite_web_pkg,
    $gw_mod_wsgi_pkg,
    $gw_pycairo_pkg,
    $gw_python_memcached_pkg,
    $gw_pytz_pkg,
  )

  anchor { 'graphite_web::begin': } ->
  class { 'graphite_web::install': } ->
  class { 'graphite_web::config': } ~>
  class { 'graphite_web::service': } ->
  anchor { 'graphite_web::end': }

}
