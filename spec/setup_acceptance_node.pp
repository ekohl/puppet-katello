class { 'foreman::repo':
  repo => 'nightly',
}
class { 'katello::repo':
  repo_version => 'nightly',
}
class { 'candlepin::repo':
  version => 'nightly',
}

group { 'foreman':
  ensure => present,
}

if $facts['os']['release']['major'] == '8' {
  package { 'glibc-langpack-en':
    ensure => installed,
  }
}
