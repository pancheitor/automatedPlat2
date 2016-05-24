exec { "sources":
    command => "/usr/bin/add-apt-repository -y ppa:gluster/glusterfs-3.5",
}

exec { "update":
    command => "/usr/bin/apt-get update;/bin/cp /vagrant/configfiles/hosts /etc/hosts",
    require => Exec['sources']
}

exec { "installs":
    require => Exec['update'],
    command => "/usr/bin/apt-get install -y python-software-properties software-properties-common glusterfs-server nfs-common nfs-kernel-server"
}

exec { "modprobe":
    require => Exec['installs'],
    command => "/sbin/modprobe nfs; /bin/rm -rf /data; /bin/mkdir /data; /bin/mkdir /data/brick1; /bin/mkdir /data/brick1/gv0; cp /vagrant/configfiles/hosts /etc/hosts"
}
