# Actualizar los repositorios de paquetes
exec { "apt-get update":
    command => "/usr/bin/apt-get update"
}
# Instalacion de haproxy
package { "haproxy":
    ensure => present,
    require => Exec["apt-get update"]
} 

exec { "copyconfig":
    require => Package["haproxy"],
    command => "/bin/cp /vagrant/configfiles/hosts /etc/hosts;/bin/cp -R /vagrant/configfiles/lb/* /; service haproxy restart"
}
