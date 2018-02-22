class acme_vault::requestor (
    $user               = $::acme_vault::params::user,
    $group              = $::acme_vault::params::group,
    $home_dir           = $::acme_vault::params::home_dir,

    $contact_email      = $::acme_vault::params::contact_email,
    $staging            = $::acme_vault::params::staging,
    $staging_url        = $::acme_vault::params::staging_url,
    $prod_url           = $::acme_vault::params::prod_url,

    $acme_revision      = $::acme_vault::params::acme_revision,
    $acme_repo_path     = $::acme_vault::params::acme_repo_path,
    $acme_script        = $::acme_vault::params::acme_script,
    $dns_api_username   = $::acme_vault::params::dns_api_username,

    $domains            = $::acme_vault::params::domains,
    $vault_token        = $::acme_vault::params::vault_token,
    $vault_addr         = $::acme_vault::params::vault_addr,
    $vault_bin          = $::acme_vault::params::vault_bin,

) inherits acme_vault::params {

  #  include acme_vault::user
    # create acme_vault user
    user { $user:
      ensure     => present,
      gid        => $group,
      system     => true,
      home       => $home_dir,
      managehome => true,
    }

    file { $home_dir:
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => "0750",
    }

    # copy vault binary? install via module?
    #TODO put in init
    # vault module isn't too flexible for install only, just copy in binary

    #include ::vault::install
    #class { '::vault::install':
    #  manage_user => false,
    #}
  
    file { $vault_bin:
        ensure => present,
        owner  => "root",
        group  => "root",
        mode   => "0555",
        source => "puppet:///modules/acme_vault/vault",
    }

    # variables in bashrc

		file { "$home_dir/.bashrc":
			ensure  => present,
			owner   => $user,
      group   => $group,
      mode    => "0600",
      content => template("acme_vault/bashrc"),
    }


    # checkout acme repo
    vcsrepo { $acme_repo_path:
      ensure   => present,
      provider => git,
      source   => "https://github.com/Neilpang/acme.sh.git",
      revision => $acme_revision,
    }

    notice("$domains")
    # copy down issue scripts

    $domains.each |$domain, $d_list| {
      file {"/${home_dir}/${domain}.sh":
        ensure => present,
        mode   => "0700",
        owner  => $user,
        group  => $group,

        content       => epp("acme_vault/domain.epp", {
          acme_script => "$acme_script",
          domain      => $domain,
          domains     => $d_list,
          staging     => $staging,
          staging_url => $staging_url,
          prod_url    => $prod_url,
          } )
      }
    }


}



