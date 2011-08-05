# Usage:
#   apt::ftparchive::dist { 'squeeze':
#     rootdir => '/path/to/root',
#     sections => "main",
#     archs => "i386",
#     source => true,
#     vendor => "mydomain"
#   }
#
define apt::ftparchive::dist ( $rootdir, $archs, $sections = 'main', $source = 'false', $vendor, $keysig ) {
  File {
    require => Exec["$rootdir"],
    notify => Exec["ftparchive-$rootdir"],
    recurse => true,
  }

  file {
    "$rootdir/dists/$name":
      ensure => directory,
      source => 'puppet:///modules/apt/ftparchive-distsdir';
    "$rootdir/pool/dists/$name":
      ensure => directory,
      source => 'puppet:///modules/apt/ftparchive-pooldir';
    "$rootdir/apt-release-$name.conf":
      content => template('apt/apt-release.conf.erb');
  }

  concat::fragment { "apt-ftparchive.conf-${name}":
    target => "${rootdir}/apt-ftparchive.conf",
    content => template('apt/apt-ftparchive.conf-dist.erb'),
  }

  exec { "aptrelease-$name-$rootdir":
    command => "/usr/bin/apt-ftparchive release -c ${rootdir}/apt-release-$name.conf ${rootdir}/dists/$name > ${rootdir}/dists/$name/Release",
    require => File["${rootdir}/apt-release-$name.conf"]
  }

  exec { "aptrelease-$name-sign-$rootdir":
    command => "/usr/bin/gpg --batch --yes --sign -ba --default-key $keysig -o ${rootdir}/dists/$name/Release.gpg ${rootdir}/dists/$name/Release",
    require => Exec["aptrelease-$name-$rootdir"],
  }
}
