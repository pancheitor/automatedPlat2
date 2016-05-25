exec { "hosts":
    command => "/bin/cp /vagrant/configfiles/hosts /etc/hosts; /bin/rm -rf /vagrant/data/brick2; /bin/mkdir /vagrant/data/brick2"
}

class { 'gluster':
  package_ensure => 'latest',
  service_ensure => 'running',
}

gluster_peer { ['storage1','storage2']:
  ensure => present,
}

gluster_volume { 'volume1':
  replica => 2,
  bricks => [
    'storage1:/vagrant/data/brick1',
    'storage2:/vagrant/data/brick2',
  ],
}
