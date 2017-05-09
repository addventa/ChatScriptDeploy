#!/bin/bash
git config --global user.email "${GIT_EMAIL}"
git config --global user.name "${GIT_NAME}"
git config --global push.default simple
git remote add origin https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git
git fetch --tags
git tag $GIT_TAG -a -m "HelloBot"
git push origin $GIT_BRANCH && git push origin $GIT_BRANCH --tags
ls -aRZZ