# = Class: yum
#
# yum の設定を管理するクラス。
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
class yum {
  package { 'yum': }

  file { '/etc/yum.conf':
    ensure => present,
    require => Package['yum'],
  }

}


define yum::mirror::partial () {

}
