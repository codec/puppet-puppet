class puppet::deploy (
  $ensure               = 'present',
  $source               = 'puppet:///modules/puppet/puppet_deploy.rb',
  $frequency            = 6,
  $interval_in_minutes  = 60
) {

  # Since 3aefec78893778f020759f947659e0f2bf30d776 we have
  # librarian-puppet support. See http://librarian-puppet.com/
  package { 'librarian-puppet':
    ensure   => $ensure,
    provider => gem,
  }

  file { '/etc/puppet/environments':
    ensure => directory,
    mode   => 0755,
    owner  => 'root',
    group  => 'root',
    before => Class['puppet::server'],
  }

  # split_filename is ugly, but necessary :(
  # this is also kinda wrong
  $split_filename   = split($source, '/')
  $deploy_filename  = $split_filename[-1]

  file { "/usr/local/bin/${deploy_filename}":
    ensure => $ensure,
    owner  => root,
    group  => root,
    mode   => 0750,
    source => $source,
  }

  cron { "Puppet: ${deploy_filename}":
    ensure  => $ensure,
    user    => root,
    command => '/usr/local/bin/${deploy_filename} 1>/dev/null 2>/dev/null',
    minute  => '*/20',
    require => File["/usr/local/bin/${deploy_filename}"];
  }

  if $ensure == 'present' {
    mcollective::plugin {'agent/deploy': has_ddl => true, module => 'puppet' }
  }
}
