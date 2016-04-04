# == class graphite_web::auth
#
#
class graphite_web::auth {
  exec { 'htpasswd':
    command => 'htpasswd -b /etc/httpd/conf/htpasswd graphite graphite',
    creates => '/etc/httpd/conf/htpasswd'
  }
}
