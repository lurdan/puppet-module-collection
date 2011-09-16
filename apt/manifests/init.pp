# = Class: apt
#
#
# Parameters:
#
# Defines:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class apt ( $repo = false ) {
  package {
    'debian-archive-keyring':
      ensure => latest;
  }

  case $repo {
    'ftparchive': {
      package { 'apt-utils': ensure => installed, }
      Package['apt-utils'] -> Apt::Ftparchive::Root <| |>
      file { '/usr/local/bin/update-apt-archive':
        mode => 750, owner => root, group => 0,
        source => 'puppet:///modules/apt/update-apt-archive',
      }
    }
    'mini-dinstall': {
    }
    'reprepro': {
    }
  }

  exec {
    'apt-updated': command => '/usr/bin/apt-get update';
## uncomment after puppet issues #6748, #7422, #8050 solved
#    'apt-preseed-cleanup':
#      command => '/usr/bin/rm -f /var/cache/debconf/*.preseed',
#      refreshonly => true;
  }

  Apt::Key <| |> -> Apt::Conf <| |> -> Exec['apt-updated']
  Apt::Source <| |> -> Exec['apt-updated']
  Apt::Preference <| |> -> Exec['apt-updated']
  Exec['apt-updated'] -> Package <| |> #-> Exec['apt-preseed-cleanup']
}
