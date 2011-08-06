class openssh (
  $version = 'present',
  $client = true,
  $client_config = false,
  $server = true,
  $server_config = false,
  $server_init_changes = false,
  $server_init_onlyif = ''
) {
  if $client {
    class { 'openssh::client':
      version => $version,
      client_config => $client_config,
    }
  }
  if $server {
    class { 'openssh::server':
      version => $version,
      active => $server,
      server_config => $server_config,
      init_changes => $server_init_changes,
      init_onlyif => $server_init_onlyif,
    }
  }
}
