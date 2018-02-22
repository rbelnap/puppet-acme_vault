class acme_vault::deploy(
    $user                  = $::acme_vault::params::user,
    $group                 = $::acme_vault::params::group,
    $home_dir              = $::acme_vault::params::home_dir,

    $vault_token           = $::acme_vault::params::vault_token,
    $cert_destination_path = $::acme_vault::params::cert_destination_path,
    $domains               = $::acme_vault::params::domains,

) inherits acme_vault::params {

}


