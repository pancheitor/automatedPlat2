# Actualizar los repositorios de paquetes
exec { "apt-get update":
    command => "/usr/bin/apt-get update"
}
# Instalación del servidor de MySQL
package { "mysql-server":
    ensure => present,
    require => Exec["apt-get update"]
}
 
# Arrancar el servicio de MySQL
service { "mysql":
    ensure => running,
    require => Package["mysql-server"]
} 

# Editar password del usuario root de mysql
exec { "set-mysql-root-password":
    unless => "mysqladmin -u root -p1234 status",
    command => "mysqladmin -u root password 1234",
    require => Service["mysql"],
    path => "/bin:/usr/bin",
}
# Agregar usuario web (Recomiendo que si es produccion no sea root)
exec { "set-mysql-user":
    command => "mysql -uroot -p1234 -e\"CREATE USER 'root'@'192.168.50.4' IDENTIFIED BY '1234'\"; GRANT ALL on *.* TO 'root'@'192.168.50.4'; flush privileges;",
    path => "/bin:/usr/bin",
}
