#!/usr/bin/env bash

export PATH=/usr/local/bin/:$PATH

git config --global push.followTags true

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.cp cherry-pick

git config --global alias.p push
git config --global alias.pf 'push -f'
git config --global alias.pfn 'push -f --no-verify'
git config --global alias.pn 'push --no-verify'

git config --global alias.ra 'rebase --abort'
git config --global alias.rc 'rebase --continue'
git config --global alias.rs 'rebase --skip'

git config --global alias.mff 'merge --ff-only'
