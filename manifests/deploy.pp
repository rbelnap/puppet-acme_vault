class acme_vault::deploy(
    $user                  = $::acme_vault::params::user,
    $group                 = $::acme_vault::params::group,
    $home_dir              = $::acme_vault::params::home_dir,

    $cert_destination_path = $::acme_vault::params::cert_destination_path,
    $domains               = $::acme_vault::params::domains,
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

  if $restart {
    $cron_command = "${home_dir}/check_cert.sh ${domain} ${cert_destination_path} && ${restart_command}"
  } else {
    $cron_command = "${home_dir}/check_cert.sh ${domain} ${cert_destination_path}"
  }


  notice($user)
  $domains.each |$domain| {
    cron { "${domain}_deploy":
      command => $cron_command,
      user    => $user,
      weekday => 2,
    }
  }





}


