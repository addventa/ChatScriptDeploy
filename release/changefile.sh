#!/bin/bash
git config --global user.email "${GIT_EMAIL}"
git config --global user.name "${GIT_NAME}"
git config --global push.default simple
msg="Tag Generated from TravisCI for build $TRAVIS_BUILD_NUMBER"
echo "$msg" >> $TRAVIS_BUILD_DIR/build.txt
git add $TRAVIS_BUILD_DIR/build.txt
git commit -m "Update build version file with $TRAVIS_BUILD_NUMBER"