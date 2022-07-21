#!/usr/bin/env bash

set -e
set -x

ruby changelog-bump.rb
git add CHANGELOG.org lib/version.rb
# Version will have been incremented at this point by changelog-bump.rb.
version="v0.$(./version.rb).0"
git commit -m "$version"
# TODO: -a is unsigned (annotated) tagging, use signed tagging.
git tag "$version"
git push --follow-tags
