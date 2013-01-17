# Class: puppet::server::passenger::debian
#
# This class installs and configures Passenger for Puppet on Debian
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppet::server::passenger::debian {
  package { 'puppetmaster-passenger':
    ensure  => present,
    require => Apt::Source['puppetlabs']
  }
}