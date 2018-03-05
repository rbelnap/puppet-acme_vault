# Configuration for deploying certs in vault to the filesystem
#

class acme_vault::deploy(
    $user                  = $::acme_vault::common::user,
    $group                 = $::acme_vault::common::group,
    $home_dir              = $::acme_vault::common::home_dir,
    $domains               = $::acme_vault::common::domains,

    $cert_destination_path = $::acme_vault::params::cert_destination_path,
    $restart               = $::acme_vault::params::restart,
    $restart_command       = $::acme_vault::params::restart_command,

) inherits acme_vault::params {
  include acme_vault::common

  # copy down cert check script
  file {"${home_dir}/check_cert.sh":
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => '0750',
    source => 'puppet:///modules/acme_vault/check_cert.sh',
  }

  # ensure destination path exists
  file {$cert_destination_path:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0750',
  }

  # cron job for deploy
  if $restart {
    $restart_suffix = "&& ${restart_command}"
  } else {
    $restart_suffix = ''
  }

  # go through each domain, setup cron, and ensure the destination dir exists
  $domains.each |$domain, $d_list| {
    cron { "${domain}_deploy":
      command => "${home_dir}/check_cert.sh ${domain} ${cert_destination_path} ${restart_suffix}",
      user    => $user,
      weekday => 2,
      hour    => 11,
      minute  => 17,
    }

    file {"${cert_destination_path}/${domain}":
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => '0750',
    }
  }

}


