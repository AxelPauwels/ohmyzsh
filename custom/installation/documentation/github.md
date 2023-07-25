# GitHub

## Multiple ssh keys

In a nutshell: choose your own Host-name and map these Host's to your own settings in ~/.git/config

See more [here](https://gist.github.com/Jonalogy/54091c98946cfe4f8cdab2bea79430f9)

### Update local git-config files
(Update existing repo upstreams with CLI command [here](#update-a-existing-repo))

Example `~/Project-a/.git/config`

```md
[user]
    name = axel-pauwels_ravago
    email = axel.pauwels@ravago.com
[remote "origin"]
    url = git@my-custom-host-name:ravago-sdc/ims-office-front.git
    fetch = +refs/heads/*:refs/remotes/origin/*
```

Notice that we've changed the default `git@github.com` to `git@my-custom-host-name` in the url

Example `~/Project-b/.git/config`

```md
[user]
    name = AxelPauwels
    email = axelpauwels.be@gmail.com
[remote "origin"]
    url = git@github.com-AxelPauwels:AxelPauwels/ohmyzsh.git
    fetch = +refs/heads/*:refs/remotes/origin/*
```

Notice the `-AxelPauwels` in the url

### Update ssh config file

Example ~/.ssh/config

```md
Host my-custom-host-name
    HostName github.com
    User git
    IdentityFile ~/.ssh/axel_ravago_id_rsa
    IdentitiesOnly yes
    AddKeysToAgent yes
    ForwardAgent yes
    UseKeychain yes

Host github.com-AxelPauwels
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
    AddKeysToAgent yes
    ForwardAgent yes
    UseKeychain yes
```

Now git actions (pull, push) will be matched to the `Host` and the correct settings wil be used

### Cloning a repo now...
Now we have to add also the username to the clone command:

Before:
```shell
git clone git@github.com:ravago-sdc/wms-front.git wms-front
```

Now with a custom Host:
```shell
git clone git@my-custom-host-name:ravago-sdc/wms-front.git wms-front
```

### Update a existing repo
Instead of editing the config file at project-x/.git/config you can

Check your remotes:
```shell
git remote -v 
```

And update the upstream:
```shell
git remote set-url origin git@my-custom-host-name:ravago-sdc/wms-front.git
```

## Create GitHub PAT (Personal Access Tokens)

Could be usefull for GitHubCli for example.

Create a token:

- Go to the GitHub website and sign in to your account.
- Click on your profile picture in the top-right corner and select "Settings."
- In the left sidebar, click on "Developer settings" and then select "Personal access tokens."
- Click on the "Generate new token" button.
- Provide a suitable description for the token.
- Select the scopes or permissions you want to grant to the token. For interacting with repositories, the "repo" scope
  is usually necessary.
- Click on the "Generate token" button at the bottom of the page.
- GitHub will generate a new token for you. Make sure to copy it as you won't be able to see it again.
