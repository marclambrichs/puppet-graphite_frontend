# == Class graphite_frontend::params
#
#
class graphite_frontend::params {
  $apache_service_name         = 'httpd'
  $carbonlink_hosts            = {}
  $carbonlink_timeout          = 1.0
  $gw_django_version           = present
  $gw_django_pkg               = 'python-django'
  $gw_django_tagging_version   = present
  $gw_django_tagging_pkg       = 'python-django-tagging'
  $gw_graphite_web_version     = present
  $gw_graphite_web_pkg         = 'graphite-web'
  $gw_mod_wsgi_version         = present
  $gw_mod_wsgi_pkg             = 'mod_wsgi'
  $gw_pycairo_version          = present
  $gw_pycairo_pkg              = 'pycairo'
  $gw_python_memcached_pkg     = 'python-memcached'
  $gw_python_memcached_version = present
  $gw_pytz_version             = present
  $gw_pytz_pkg                 = 'pytz'
  $gw_webapp_dir               = '/etc/graphite-web'
  $ls_carbonlink_hosts         = []
  $ls_carbonlink_timeout       = 1.0
  $ls_conf_dir                 = '/opt/graphite/conf'
  $ls_content_dir              = '/usr/share/graphite/webapp/content'
  $ls_db_name                  = '/opt/graphite/storage/graphite.db'
  $ls_db_engine                = 'django.db.backends.sqlite3'
  $ls_default_cache_duration   = 60
  $ls_graphite_root            = '/usr/share/graphite'
  $ls_index_file               = '/var/lib/graphite-web/index'
  $ls_log_dir                  = '/opt/graphite/storage/log/webapp'
  $ls_memcached_hosts          = ['127.0.0.1:11211']
  $ls_secret_key               = 'changeme'
  $ls_storage_dir              = '/opt/graphite/storage'
  $ls_timezone                 = 'Europe/Amsterdam'
  $ls_whisper_dir              = '/opt/graphite/storage/whisper'
  $manage_packages             = true
  $memcached_enabled           = false
  $vhosts                      = {}
}
