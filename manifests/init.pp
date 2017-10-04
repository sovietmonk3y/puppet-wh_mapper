class wh_mapper (
  $path_to_python = '/usr/bin/python',
  $source_dir     = '/usr/share/wh_mapper'
) {
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
    provider => 'pip',
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

  file { 'wh_mapper_systemd_config':
    ensure  => 'present',
    content => template('wh_mapper/systemd/wh_mapper.service.erb'),
    path    => '/etc/systemd/system/wh_mapper.service'
  }

  service { 'wh_mapper.service':
    enable   => true,
    ensure   => 'running',
    provider => 'systemd',
    require  => File['wh_mapper_systemd_config']
  }
}