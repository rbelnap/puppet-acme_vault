class acme_vault::params {
    # settings for requestor
    $user       = 'acme'
    $group      = 'apache'
    $home_dir   = '/home/acme_vault'
    $contact_email = ''

    # whether to use the letsencrypt staging url, set those urls
    $staging     = true
    $staging_url = 'https://acme-staging-v02.api.letsencrypt.org/directory'
    $prod_url    = 'https://acme-v02.api.letsencrypt.org/directory'

    $acme_revision = 'HEAD'
    $acme_repo_path = "$home_dir/acme.sh"
    $acme_script    = "$acme_repo_path/acme.sh"
    # domains list TODO should be a mapping name -> domains

    $domains     = ''

    # authentication
    $vault_token = ''
    $vault_addr  = ''
    $vault_bin   = "$home_dir/vault"

    $dns_api_username = ''
    # settings for deploy

    $cert_destination_path = '/etc/acme/'

    
    # control if we want to actually run acme_vault - usefull for rollout
    $skip_run = true
}
