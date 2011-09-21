class krfilter ( $target = 'ALL2', $active = false ) {
  file {
    '/etc/krfilter':
      ensure => directory,
      source => 'puppet:///modules/krfilter/krfilter',
      recurse => true,
      force => true;
    '/etc/init.d/krfilter':
      mode => 755,
      content => template('krfilter/init.erb');
  }
 
  service { 'krfilter':
    ensure => $active ? {
      true => running,
      default => stopped,
    },
    enable => $active,
    require => File['/etc/krfilter', '/etc/init.d/krfilter'],
  }
}

