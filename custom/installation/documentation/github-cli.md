# GitHub Cli

See more [here](https://cli.github.com/manual/)

## Install

```shell
brew install gh
```

## Authenticating using GitHub tokens

When trying to use gh-cl, you need to login first by command `gh auth login`.
At some point je need to authenticate.
You can use a PAT (Personal Access Token) from GitHub (see below how te create one).
Here is an overview how gh auth login command looks like:

```md
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations? SSH
? Upload your SSH public key to your GitHub account? /Users/axel/.ssh/axel_ravago_id_rsa.pub
? Title for your SSH key: axel_ravago_id_rsa
? How would you like to authenticate GitHub CLI? Paste an authentication token
Tip: you can generate a Personal Access Token here https://github.com/settings/tokens
The minimum required scopes are 'repo', 'read:org', 'admin:public_key'.
? Paste your authentication token: ****************************************

- gh config set -h github.com git_protocol ssh
  ✓ Configured git protocol
  ✓ SSH key already existed on your GitHub account: /Users/axel/.ssh/axel_ravago_id_rsa.pub
  ✓ Logged in as axel-pauwels_ravago
```

## Creating a PAT on GitHub:

- Go to the GitHub website and sign in to your account.
- Click on your profile picture in the top-right corner and select "Settings."
- In the left sidebar, click on "Developer settings" and then select "Personal access tokens."
- Click on the "Generate new token" button.
- Provide a suitable description for the token.
- Select the scopes or permissions you want to grant to the token. For interacting with repositories, the "repo" scope
  is usually necessary.
- Click on the "Generate token" button at the bottom of the page.
- GitHub will generate a new token for you. Make sure to copy it as you won't be able to see it again.
