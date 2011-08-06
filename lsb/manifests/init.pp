class lsb {
  package {
    'lsb':
      name => $::operatingsystem ? {
        /(?i-mx:debian|ubuntu)/ => 'lsb',
        /(?i-mx:redhat|centos)/ => 'redhat-lsb',
      };
  }
}
