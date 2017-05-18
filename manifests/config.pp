# Katello Config
class katello::config {

  class { '::katello::config::pulp_client': }

  file { '/usr/share/foreman/bundler.d/katello.rb':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { "${katello::config_dir}/katello.yaml":
    ensure  => file,
    content => template('katello/katello.yaml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    before  => [Class['foreman::database'], Exec['foreman-rake-db:migrate']],
    notify  => [Service['foreman-tasks'], Class['foreman::service']],
  }

  foreman::config::passenger::fragment{ 'katello':
    ssl_content => file('katello/katello-apache-ssl.conf'),
  }

  foreman::config::passenger::fragment{ 'pulp':
    content     => file('katello/pulp-apache.conf'),
    ssl_content => file('katello/pulp-apache-ssl.conf'),
  }

  # NB: we define this here to avoid a dependency cycle. It is not a problem if
  # this dir exists before the pulp RPMs are installed.
  file { '/var/lib/pulp':
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0755',
  }

  file { $katello::repo_export_dir:
    ensure => directory,
    owner  => $katello::user,
    group  => $katello::group,
    mode   => '0755',
  }

}
