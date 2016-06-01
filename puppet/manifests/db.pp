# Actualizar los repositorios de paquetes
exec { "apt-get update":
    command => "/usr/bin/apt-get update"
}
# Instalación del servidor de MySQL
#package { "mysql-server":
#    ensure => present,
#    require => Exec["apt-get update"]
#}
 
# Arrancar el servicio de MySQL
#service { "mysql":
#    ensure => running,
#    require => Package["mysql-server"]
#} 

# Editar password del usuario root de mysql
#exec { "set-mysql-root-password":
#º    unless => "mysqladmin -u root -p1234 status",
#   command => "mysqladmin -u root password 1234",
#    require => Service["mysql"],
#    path => "/bin:/usr/bin",
#}
$mysql_root_pw = '1234'

class { '::mysql::server':
      root_password => '1234',
      restart => true,
      override_options => {
        mysqld => { bind-address => '0.0.0.0'} #Allow remote connections
      },
      # ... other class options
}
mysql_user{ 'root@%':
        ensure  => present,
        password_hash => mysql_password('1234'),
        require  => Class['mysql::server'],
      # ... other class options
}
mysql_grant{'root@%/mysql.*':
        user  => 'root@%',
        table => 'mysql.*',
        privileges => ['ALL'],
}

