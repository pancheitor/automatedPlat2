# Actualizar los repositorios de paquetes
exec { "key":
    command => "/usr/bin/wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -"
}
exec { "sources":
    command => "/bin/echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list",
    require => Exec['key']
}

exec { "update":
    command => "/usr/bin/apt-get update",
    require => Exec['sources']
}

#exec { "jdk":
#    require => Package['apache2'],
#    command => "/usr/bin/apt-get install -y openjdk-7-jdk"
#}

package { "default-jdk":
    ensure => present,
    require => Exec["update"]
} 
 
# Instalación de Apache
package { "apache2":
    ensure => present,
    require => Package["default-jdk"]
}
 
# Arrancar el servicio de Apache
service { "apache2":
    ensure => running,
    require => Package["apache2"]
}
 
# Lista de paquetes de PHP para instalar
#$packages = [
#    "php5",
#    "php5-cli",
#    "php5-mysql",
#    "php5-dev",
#    "php5-curl",
#    "php-apc",
#    "libapache2-mod-php5"
#]
 
# Instalación de los paquetes de PHP
#package { $packages:
#    ensure => present,
#    require => Exec["update"],
#    notify => Service["apache2"]
#}

package { "jenkins":
    ensure => present,
    require => Service["apache2"]
}

# Arrancar el servicio de Apache
service { "jenkins":
    ensure => running,
    require => Package["jenkins"]
}

