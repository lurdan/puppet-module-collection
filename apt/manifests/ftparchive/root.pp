# Usage:
#  apt::ftparchive { 'repo-name':
#    rootdir => '/path/to/repo/debian',
#  }
define apt::ftparchive::root ( $rootdir ) {

  exec { "make-${rootdir}":
    command => "/bin/mkdir -p ${rootdir}/dists ${rootdir}/pool/dists ${rootdir}/.scratch",
  }
  file { "$rootdir":
    ensure => directory,
    before => Exec["make-$rootdir"],
  }

  concat { "${rootdir}/apt-ftparchive.conf": }
  concat::fragment { 'apt-ftparchive.conf-general':
    target => "${rootdir}/apt-ftparchive.conf",
    content => template('apt/apt-ftparchive.conf.erb'),
    order => '00',
  }

  exec { "ftparchive-${rootdir}":
    command => "/usr/bin/apt-ftparchive generate ${rootdir}/apt-ftparchive.conf",
    require => Concat["${rootdir}/apt-ftparchive.conf"]
  }
}
