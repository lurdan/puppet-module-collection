class {
  'stdlib':;
  'concat::setup':;
}

Concat {
  warn => true,
  force => true,
}

Exec {
  logoutput => on_failure,
}

#import 'nodes'
