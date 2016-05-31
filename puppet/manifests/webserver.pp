# Actualizar los repositorios de paquetes
exec { "apt-get update":
    command => "/usr/bin/apt-get update"
}
# Instalacion de cliente Gluster
package { "glusterfs-client":
    ensure => present,
    require => Exec["apt-get update"]
} 
# Lista de paquetes de PHP para instalar
$packages = [
    "php5",
    "php5-mysql",
    "php5-mcrypt",
    "libapache2-mod-php5",
    "mysql-client"
]

package { "apache2":
    ensure => present,
    require => Exec["apt-get update"]
}
 
# Instalación de los paquetes de PHP
package { $packages:
    ensure => present,
    require => Exec["apt-get update"],
    notify => Package["apache2"]
}

exec { "mount":
    require => Package["glusterfs-client"],
    command => "/bin/cp /vagrant/configfiles/hosts /etc/hosts;/bin/cp -R /vagrant/web/* /var/www/html/"
}
