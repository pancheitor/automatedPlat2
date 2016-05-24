exec { "sources":
    command => "/usr/bin/add-apt-repository -y ppa:gluster/glusterfs-3.5",
}

exec { "update":
    command => "/usr/bin/apt-get update",
    require => Exec['sources']
}

exec { "installs":
    require => Exec['update'],
    command => "/usr/bin/apt-get install -y python-software-properties software-properties-common glusterfs-server nfs-common nfs-kernel-server"
}

exec { "modprobe":
    require => Exec['installs'],
    command => "/sbin/modprobe nfs; /bin/rm -rf /data; /bin/mkdir /data; /bin/mkdir /data/brick1; /bin/mkdir /data/brick1/gv0"
}
exec { "montar":
    require => Exec['modprobe'],
    command => "/usr/sbin/gluster peer probe storage1; /usr/sbin/gluster volume create gv0 replica 2 storage1:/data/brick1/gv0/web storage2:/data/brick1/gv0/web; /usr/sbin/gluster volume start gv0"
}
