# Usage:
#  apt::ftparchive { 'repo-name':
#    rootdir => '/path/to/repo/debian',
#  }
define apt::ftparchive::root ( $rootdir ) {

  file { "$rootdir":
    source => 'puppet:///modules/apt/ftparchive-rootdir',
    recurse => true,
  }

  concat { "${rootdir}/apt-ftparchive.conf":
    require => File["$rootdir"],
  }
  concat::fragment { 'apt-ftparchive.conf-general':
    target => "${rootdir}/apt-ftparchive.conf",
    content => template('apt/apt-ftparchive.conf.erb'),
    order => '00',
  }

  exec { "update-apt-archive-${rootdir}":
    command => "/usr/local/bin/update-apt-archive ${rootdir}",
    require => [ File['/usr/local/bin/update-apt-archive'], Concat["${rootdir}/apt-ftparchive.conf"] ]
  }
  Apt::Ftparchive::Dist <| |> -> Exec["update-apt-archive-${rootdir}"]
}
