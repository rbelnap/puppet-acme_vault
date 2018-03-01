# params for both common, request, and deploy
class acme_vault::params {
    # settings for acme user
    $user       = 'acme'
    $group      = 'apache'
    $home_dir   = '/home/acme_vault'
    $contact_email = ''
    $domains     = undef

    # authentication
    $vault_token = undef
    $vault_addr  = undef
    $vault_bin   = "${home_dir}/vault"

    $vault_prefix   = '/secret/letsencrypt/'

    # whether to use the letsencrypt staging url, set those urls
    $staging     = false
    $staging_url = 'https://acme-staging-v02.api.letsencrypt.org/directory'
    $prod_url    = 'https://acme-v02.api.letsencrypt.org/directory'

    $acme_revision = 'HEAD'
    $acme_repo_path = "${home_dir}/acme.sh"
    $acme_script    = "${acme_repo_path}/acme.sh"

    # lexicon 
    $lexicon_provider   = undef 
    $lexicon_username   = undef 
    $lexicon_token      = undef 

    # settings for deploy

    $cert_destination_path = '/etc/acme/'

    $restart         = false
    $restart_command = 'echo restart!'

}
