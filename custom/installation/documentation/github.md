# GitHub

## Multiple ssh keys

See more [here](https://gist.github.com/Jonalogy/54091c98946cfe4f8cdab2bea79430f9)

### Update local git-config files

Example `~/Project-a/.git/config`

```md
[user]
    name = axel-pauwels_ravago
    email = axel.pauwels@ravago.com
[remote "origin"]
    url = git@github.com-axel-pauwels_ravago:ravago-sdc/ims-office-front.git
    fetch = +refs/heads/*:refs/remotes/origin/*
```

Notice the `-axel-pauwels_ravago` in the url (which is your GitHub username)!

Example `~/Project-b/.git/config`

```md
[user]
    name = AxelPauwels
    email = axelpauwels.be@gmail.com
[remote "origin"]
    url = git@github.com-AxelPauwels:AxelPauwels/ohmyzsh.git
    fetch = +refs/heads/*:refs/remotes/origin/*
```

Notice the `-AxelPauwels` in the url (which is your GitHub username)!

### Update ssh config file

Example ~/.ssh/config

```md
Host github.com-axel-pauwels_ravago
HostName github.com
User git
IdentityFile ~/.ssh/axel_ravago_id_rsa
IdentitiesOnly yes

Host github.com-AxelPauwels
HostName github.com
User git
IdentityFile ~/.ssh/id_ed25519
IdentitiesOnly yes
```

Notice here also the usernames in the Hosts

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
