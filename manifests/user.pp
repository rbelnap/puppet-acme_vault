class acme_vault::user  {

    # create acme_vault user
    user { $acme_vault::user:
        ensure     => present,
        gid        => $acme_vault::group,
        system     => true,
        home       => $acme_vault::home_dir,
        managehome => false,
    }



}
