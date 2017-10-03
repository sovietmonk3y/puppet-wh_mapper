class wh_mapper {
  package { 'libmysqlclient-dev':
    ensure => 'present'
  }

  package { 'mysql-python':
    ensure   => 'present',
    provider => 'pip',
    require  => [Class['python'], Package['python-pip', 'libmysqlclient-dev']]
  }

  package { 'south':
    ensure   => 'present',
    provider => 'pip'
    require  => [Class['python'], Package['python-pip']]
  }

  package { 'django':
    ensure   => '1.5.2',
    provider => 'pip',
    require  => [Class['python'], Package['python-pip']]
  }

  package { 'tornado':
    ensure   => '3.1.1',
    provider => 'pip',
    require  => [Class['python'], Package['python-pip']]
  }
}