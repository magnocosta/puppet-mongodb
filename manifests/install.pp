# -*- mode: ruby -*-
# vi: set ft=ruby :

class mongodb::install {

    exec {"get-mongodb-key":
        command => "/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10",
        unless => "/usr/bin/apt-key list| /bin/grep -c 10gen",
        require => Class["common::basic"]
    }

    exec {"install-mongodb-repo":
        command => "/bin/echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' >> /etc/apt/sources.list",
        unless => "/bin/grep 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart' -c /etc/apt/sources.list",
        require => Exec['get-mongodb-key']
    }


    exec { "apt-update-mongodb":
        command => "/usr/bin/apt-get update -y -q",
        timeout => 0,
        require => Exec['install-mongodb-repo']
    }

    package {"mongodb-10gen":
        ensure => "present",    
        require => Exec['apt-update-mongodb']
    }

}
