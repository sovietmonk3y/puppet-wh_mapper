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

  exec { 'wh_mapper_db_setup':
    command => "${source_dir}/manage.py syncdb --noinput --migrate",
    creates => '/var/lib/mysql/wh_mapper/auth_user.ibd',
    require => [
      Mysql::Db['wh_mapper'], Package['django', 'mysql-python', 'south']]
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
    require  => [Exec['wh_mapper_db_setup'], File['wh_mapper_systemd_config']]
  }
}