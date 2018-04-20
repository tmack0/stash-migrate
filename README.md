Stash-Migration
===============

This repo contains a script that handles the CLI side of migrationg a GIT
repository from Gerrit style Git to Stash/BitBucket

## Install

This is just a shell script, clone it and edit to set a couple site-sepcific things

## Use

do_migrate old_repo [new-repo]

Where old_repo is the full path on the old git server to clone the project

ex:
```
# do-migration.sh stash-migration
```
or
```
# do-migration.sh some_toplevel/other_project new-other-project
```

The procedure is thus:

0. Create a temporary working directory and CD into it. This script will
   check-out the bare repo into it to perform its dance.
1. Create the repo in BitBucket via the web UI under the appropriate project
2. run this script as do-migrate.sh Old_Repo [new-repo]
3. Click the "refresh" button at the bottom of the page in BitBucket. It should
   load your repository's contents, and display the README file
   ...You do have a README file, right???????
4. The repo is migrated, disable the project in the old repo (set to hidden if its Gerrit)
5. If you have your repo checked out somewhere, update its remotes to point
   at BitBucket:
   git remote set-url origin ssh://git@your.stash.server:7999/project/new-repo.git
   note that the new repo name is all-lower-case!

### Notes:

0. ALWAYS have a README file in the top level of your repo. 
1. BitBucket has a flat repo layout. You only get project/repo.git. No heirarchy.
   If your repo was under a few paths, consider merging them all into one repo or
   renaming them. The script defaults to trimming to the last / ( ${repo##*/}
   ie: some-package/some-subproject would be some-subproject by default
2. Consider only using hypen instead of underscore
3. As mentioned in step 5, all repos are lower case. The Displayed name can/will
   show capitalization, but the URL will be all lower case. Try to not use capitalizations
