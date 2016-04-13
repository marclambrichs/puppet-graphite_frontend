# == Class: graphite_frontend
#
# Installs, configures and manages a graphite frontend
#
# For the parameters of this class, a number of prefixes have been used to differentiate
# between the variables. Legend:
# "gw_" -> all variables generally applicable for graphite-web
# "ls_" -> all variables specific to the local_settings file.
#
# === Parameters
# [*apache_group*]
#   Group name to run the apache service under
#   Type: String
# [*apache_service_name*]
#   Name to use for running the apache service
#   Type: String
#
# [*gw_django_version*]
#   Which version of django to use. Defaults to 'present'.
#   Type: String
#
# [*gw_django_pkg*]
#   Name of the django package to install.
#   Type: String
#
# [*gw_django_tagging_version*]
#   Which version of django-tagging to use. Defaults to 'present'.
#   Type: String
#
# [*gw_django_tagging_pkg*]
#   Name of the django-tagging package to install.
#   Type: String
#
# [*gw_graphite_web_version*]
#   Which version of graphite-web to use. Defaults to 'present'.
#   Type: String
#
# [*gw_graphite_web_pkg*]
#   Name of the graphite-web package to install.
#   Type: String
#
# [*gw_mod_wsgi_version*]
#   Which version of mod-wsgi to use. Defaults to 'present'.
#   Type: String
#
# [*gw_mod_wsgi_pkg*]
#   Name of the mod-wsgi package to install.
#   Type: String
#
# [*gw_pycairo_version*]
#   Which version of pycairo to use. Defaults to 'present'.
#   Type: String
#
# [*gw_pycairo_pkg*]
#   Name of the pycairo package to install.
#   Type: String
#
# [*gw_python_memcached_pkg*]
#   Name of the python-memcached package to install.
#   Type: String
#
# [*gw_python_memcached_version*]
#   Which version of python-memcached to use. Defaults to 'present'.
#   Type: String
#
# [*gw_pytz_version*]
#   Which version of pytz to use. Defaults to 'present'.
#   Type: String
#
# [*gw_pytz_pkg*]
#   Name of the pytz package to install.
#   Type: String
#
# [*gw_webapp_dir*]
#   Directory where all config and other files needed for graphite-web are to be stored.
#   Type: Absolute path
#
# [*ls_carbonlink_hosts*]
#   Hash containing (a number of) carbon cache(s) config. Example config hash:
#   ls_carbonlink_hosts = {
#     "a":{
#       $cache_query_interface      = '0.0.0.0',
#       $cache_query_port           = 7002,
#       $line_receiver_interface    = '0.0.0.0',
#       $line_receiver_port         = 2203,
#       $manhole_interface          = undef,
#       $manhole_port               = undef,
#       $udp_receiver_interface     = '0.0.0.0',
#       $udp_receiver_port          = 2203,
#       $pickle_receiver_interface  = '0.0.0.0',
#       #pickle_receiver_port       = 2204
#     }
#   }
#
# [*ls_carbonlink_timeout*]
#   Timeout for carbon-cache queries in seconds
#   Type: integer
#
# [*ls_conf_dir*]
#   Directory where config for carbon is stored.
#   Type: Absolute path
#
# [*ls_content_dir*]
#   Location of graphite-web's static content
#   Type: Absolute path
#
# [*ls_dashboard_conf*]
#   Absolute path to dashboard.conf file.
#   Type: Absolute path
#
# [*ls_db_name*]
#   Database name to use.
#   Type: String
#
# [*ls_db_engine*]
#   Database engine to use for storing graphite-web dashboards.
#   Possible values:
#   Type: String
#
# [*ls_default_cache_duration*]
#   Default expiration of cached data and images.
#   Type: integer
#
# [*ls_graphite_root*]
#   Base directory for the graphite install.
#   Type: Absolute path
#
# [*ls_graphtemplates_conf*]
#   Absolute path to graphTemplates.conf file.
#   Type: Absolute path
#
# [*ls_index_file*]
#   Location of the search index file for the database backing graphite-web
#   Type: Absolute path
#
# [*ls_log_dir*]
#   Directory to write graphite-web's log files
#   Type: Absolute path
#
# [*ls_memcached_hosts*]
#   List of memcached hosts to use if memcached_enabled is set to true.
#   Type: List(String)
#
# [*ls_secret_key*]
#   Secret key to use for
#   Type: String
#
# [*ls_storage_dir*]
#   Base directory from which whisper, rrd_dir, log_dir, and index-file default paths are referenced.
#   Type: Absolute path
#
# [*ls_timezone*]
#   Timezone to use.
#   Type: String
#
# [*ls_whisper_dir*]
#   Location of whisper data files.
#   Type: Absolute path
#
# [*manage_packages*]
#   Set to true if this module should install required packages.
#   Type: Boolean
#
# [*memcached_enabled*]
#   Set to true to enable the use of memcached with graphite-web.
#   Type: Boolean
#
# [*vhosts*]
#   Apache vhost configuration to use.
#   Type: Hash
#
# === Examples
#
#  class { 'graphite_frontend': }
#
# === Authors
#
# Marc Lambrichs <marc.lambrichs@gmail.com>
# Daniel van der Ende <daniel.vanderende@gmail.com>
#
# === Copyright
#
# Copyright 2016 Marc Lambrichs
#
class graphite_frontend (
  $apache_group                = $graphite_frontend::params::apache_group,
  $apache_service_name         = $graphite_frontend::params::apache_service_name,
  $apache_user                 = $graphite_frontend::params::apache_user,
  $ls_carbonlink_hosts         = $graphite_frontend::params::ls_carbonlink_hosts,
  $ls_carbonlink_timeout       = $graphite_frontend::params::ls_carbonlink_timeout,
  $ls_conf_dir                 = $graphite_frontend::params::ls_conf_dir,
  $ls_content_dir              = $graphite_frontend::params::ls_content_dir,
  $ls_dashboard_conf           = $graphite_frontend::params::ls_dashboard_conf,
  $ls_db_name                  = $graphite_frontend::params::ls_db_name,
  $ls_db_engine                = $graphite_frontend::params::ls_db_engine,
  $ls_default_cache_duration   = $graphite_frontend::params::ls_default_cache_duration,
  $ls_graphite_root            = $graphite_frontend::params::ls_graphite_root,
  $ls_graphtemplates_conf      = $graphite_frontend::params::ls_graphtemplates_conf,
  $ls_index_file               = $graphite_frontend::params::ls_index_file,
  $ls_log_dir                  = $graphite_frontend::params::ls_log_dir,
  $ls_memcached_hosts          = $graphite_frontend::params::ls_memcached_hosts,
  $ls_rrd_dir                  = $graphite_frontend::params::ls_rrd_dir,
  $ls_secret_key               = $graphite_frontend::params::ls_secret_key,
  $ls_storage_dir              = $graphite_frontend::params::ls_storage_dir,
  $ls_timezone                 = $graphite_frontend::params::ls_timezone,
  $ls_whisper_dir              = $graphite_frontend::params::ls_whisper_dir,
  $gw_django_version           = $graphite_frontend::params::gw_django_version,
  $gw_django_pkg               = $graphite_frontend::params::gw_django_pkg,
  $gw_django_tagging_version   = $graphite_frontend::params::gw_django_tagging_version,
  $gw_django_tagging_pkg       = $graphite_frontend::params::gw_django_tagging_pkg,
  $gw_graphite_web_pkg         = $graphite_frontend::params::gw_graphite_web_pkg,
  $gw_graphite_web_version     = $graphite_frontend::params::gw_graphite_web_version,
  $gw_mod_wsgi_version         = $graphite_frontend::params::gw_mod_wsgi_version,
  $gw_mod_wsgi_pkg             = $graphite_frontend::params::gw_mod_wsgi_pkg,
  $gw_pycairo_version          = $graphite_frontend::params::gw_pycairo_version,
  $gw_pycairo_pkg              = $graphite_frontend::params::gw_pycairo_pkg,
  $gw_python_memcached_pkg     = $graphite_frontend::params::gw_python_memcached_pkg,
  $gw_python_memcached_version = $graphite_frontend::params::gw_python_memcached_version,
  $gw_pytz_version             = $graphite_frontend::params::gw_pytz_version,
  $gw_pytz_pkg                 = $graphite_frontend::params::gw_pytz_pkg,
  $gw_webapp_dir               = $graphite_frontend::params::gw_webapp_dir,
  $manage_packages             = $graphite_frontend::params::manage_packages,
  $memcached_enabled           = $graphite_frontend::params::memcached_enabled,
  $vhosts                      = $graphite_frontend::params::vhosts,
) inherits graphite_frontend::params {

  validate_absolute_path( [
    $gw_webapp_dir,
    $ls_conf_dir,
    $ls_content_dir,
    $ls_dashboard_conf,
    $ls_graphtemplates_conf,
    $ls_index_file,
    $ls_log_dir,
    $ls_storage_dir,
    $ls_whisper_dir,
  ])

  validate_array( $ls_memcached_hosts )

  validate_bool(
    $manage_packages,
    $memcached_enabled,
  )

  validate_hash( $ls_carbonlink_hosts )
  validate_hash( $vhosts )

  validate_numeric( [
    $ls_carbonlink_timeout,
    $ls_default_cache_duration,
  ])

  validate_re( $gw_django_version, '^(present|\d+\.\d+\.\d+)$' )
  validate_re( $gw_django_tagging_version, '^(present|\d+\.\d+\.\d+)$' )
  validate_re( $gw_graphite_web_version, '^(present|\d+\.\d+\.\d+)$' )
  validate_re( $gw_mod_wsgi_version, '^(present|\d+\.\d+\.\d+)$' )
  validate_re( $gw_pycairo_version, '^(present|\d+\.\d+\.\d+)$' )
  validate_re( $gw_python_memcached_version, '^(present|\d+\.\d+\.\d+)$' )
  validate_re( $gw_pytz_version, '^(present|\d+\.\d+\.\d+)$' )

  validate_string(
    $apache_group,
    $apache_service_name,
    $gw_django_pkg,
    $gw_django_tagging_pkg,
    $gw_graphite_web_pkg,
    $gw_mod_wsgi_pkg,
    $gw_pycairo_pkg,
    $gw_python_memcached_pkg,
    $gw_pytz_pkg,
    $ls_db_name,
    $ls_db_engine,
    $ls_secret_key,
    $ls_timezone
  )


  anchor { 'graphite_frontend::begin': } ->
  class { 'graphite_frontend::install': } ->
  class { 'graphite_frontend::config': } ~>
  class { 'graphite_frontend::service': } ->
  anchor { 'graphite_frontend::end': }

}
