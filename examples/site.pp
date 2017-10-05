node default {
  include mysql::server

  mysql::db { 'wh_mapper':
    user     => 'root',
    password => '',
    require  => Class['mysql::server']
  }

  include stdlib

  class { 'python':
    pip     => 'present',
    require => Class['stdlib']
  }

  class { 'wh_mapper':
    require => [Mysql::Db['wh_mapper'], Class['python'], Package['python-pip']]
  }
}