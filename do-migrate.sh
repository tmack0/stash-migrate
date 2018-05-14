#!/bin/bash

## Clones from gerrit style git, updates remote, pushes to BitBucket (aka Stash)
##  note for sub-repos, we strip to the last / for local operations,
##  but new_repo should be explicitly set as we only do ${repo##*/} by default
##  which would lose possibly important naming info
##  Also, please use - instead of _ for consistency and note
##  BitBucket names all repos lowercase
## You probably want to run this in its own dir to not accidentally rm -rf 
##  important things that have matching names (we don't check!)

## Copyright (c) 2018 by Evernote Corporation, All rights reserved.
## Written by Theral Mackey <tmackey@evernote.com>

localgit="ssh://your.git.server:port"
bbgit="ssh://git@your.stash.server:7999"
bbproj="stashproject"

repo=$1
if [[ -z "$2" ]] ; then 
  newrepo=${repo##*/}
else
  newrepo=$2
fi

if [[ -z ${repo} ]] || [[ -z ${newrepo} ]] ; then
   echo "Use: $0 <REPO_NAME> [NEW_REPO_NAME]"
   echo " Clones and migrates <REPO_NAME> from Gerrit to BitBucket"
   echo "  if [NEW_REPO_NAME] is specified, this is used in BitBucket"
   echo "  expects the repo to already be created in BitBucket"
  exit 1
fi

git clone --bare ${localgit}/${repo}
gerr=$?
if [ $gerr -gt 0 ] ; then
  echo "Error! Check your existing repo project/name giterrno: $gerr"
  exit 1;
fi

cd ${repo##*/}.git

git remote set-url origin ${bbgit}/${bbproj}/${newrepo,,}.git
git push -u origin --all
gerr2=$?
if [ $gerr2 -gt 0 ] ; then
  echo "Error! Check your new repo project/name giterrno: $gerr2"
  exit 1;
fi

git push origin --tags
echo "# Update your remotes if this is checked out somewhere: "
echo "git remote set-url origin ${bbgit}/${bbproj}/${newrepo,,}.git"
cd -
rm -rf ${repo##*/}.git
