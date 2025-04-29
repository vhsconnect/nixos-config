### Add a machine

```bash
gpg --gen-key
gpg --list-keys
# export as gpg file
gpg --armor --export --output <path.gpg> <public-key>
# then import it on the administrating machine
gpg --import <path.gpg>
# edit to trusted
gpg --edit-key <public-key>
> fpr
> trust
> save
> quit
# finally add the new gpg user to git-crypt
git-crypt add-gpg-user <public-key>
```
