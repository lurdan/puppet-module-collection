class yum::createrepo {
  package { 'createrepo':
    ensure => installed,
  }
}

# Usage:
# yum::repository { "base-5":
#   rootdir => "/path/to/repos/dists/5/base",
# }
define yum::repository ( $rootdir ) {

  exec { "$rootdir":
    command => "/bin/bash -c \"/bin/mkdir -p ${rootdir}/{SRPMS,noarch,i386,x86_64}\"",
    #creates => "",
  }

  file {
    "$rootdir":
      ensure => directory,
      require => Exec["$rootdir"];
    # RHEL workaround
    "${rootdir}Server":
      ensure => link,
      target => "$rootdir",
      require => File["$rootdir"];
    "${rootdir}/i686":
      ensure => link,
      target => "${rootdir}/i386",
      require => File["$rootdir"];
  }

  exec { "update-yum-archive-$rootdir":
    command => "/usr/local/bin/update-yum-archive ${rootdir}",
    require => [ File['/usr/local/bin/update-yum-archive'], File["$rootdir"], ],
  }
  Yum::Repository <| |> -> Exec["update-yum-archive-${rootdir}"]
}
