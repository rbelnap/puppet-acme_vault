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

    $lexicon_provider   = $::acme_vault::params::lexicon_provider,
    $lexicon_username   = $::acme_vault::params::lexicon_username,
    $lexicon_token      = $::acme_vault::params::lexicon_token,

    $domains            = $::acme_vault::params::domains,

) inherits acme_vault::params {

    include acme_vault::common

    $requestor_bashrc_template = @(END)
export LEXICON_PROVIDER=<%= @lexicon_provider %>
export LEXICON_<%= @lexicon_provider.upcase %>_USERNAME=<%= @lexicon_username %>
export LEXICON_<%= @lexicon_provider.upcase %>_TOKEN=<%= @lexicon_token %>
END
    # variables in bashrc

		concat::fragment { "requestor_bashrc":
      target  => "${home_dir}/.bashrc",
      content => inline_template($requestor_bashrc_template),
      order   => "02",
    }


    # checkout acme repo
    vcsrepo { $acme_repo_path:
      ensure   => present,
      provider => git,
      source   => "https://github.com/Neilpang/acme.sh.git",
      revision => $acme_revision,
    }

    # create issue scripts
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
          } 
        )
      }
    }

}
