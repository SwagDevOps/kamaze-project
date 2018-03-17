#!/usr/bin/env bash

export RUBY_VERSION=2.3.3

set -e

# RVM installation ---------------------------------------------------
curl -sSL 'https://get.rvm.io' | bash -s 'stable'
. /etc/profile.d/rvm.sh

rvm use "${RUBY_VERSION}" || {
    rvm install "${RUBY_VERSION}"
    rvm use "${RUBY_VERSION}"
}

gem install --conservative    \
            --no-user-install \
            --no-post-install-message bundler

ln -sfv \
   "/usr/local/rvm/rubies/ruby-${RUBY_VERSION}/bin/ruby" \
   "/usr/local/bin/ruby$(echo ${RUBY_VERSION} | perl -pe 's#([0-9]+)\.([0-9]+)\.([0-9]+)$#$1.$2#')"
