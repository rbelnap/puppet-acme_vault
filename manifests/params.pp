class acme_vault::params {
    # settings for acme user
    $user       = 'acme'
    $group      = 'apache'
    $home_dir   = '/home/acme_vault'

    # whether to use the letsencrypt staging url, set those urls
    $staging     = true
    $staging_url = 'https://acme-staging-v02.api.letsencrypt.org/directory'
    $prod_url    = 'https://acme-v02.api.letsencrypt.org/directory'
    #TODO configurue email
    $contact_email = ''

    $acme_revision = 'HEAD'
    $acme_repo_path = "$home_dir/acme.sh"
    $acme_script    = "$acme_repo_path/acme.sh"
    $vault_prefix   = '/secret/letsencrypt/'
    $domains     = ''

    # authentication
    $vault_token = ''
    $vault_addr  = ''
    $vault_bin   = "$home_dir/vault"

    # lexicon 
    $lexicon_provider   = ''
    $lexicon_username   = ''
    $lexicon_token      = ''

    # settings for deploy

    $cert_destination_path = '/etc/acme/'

    $restart         = false
    $restart_command = "echo restart!"

}
