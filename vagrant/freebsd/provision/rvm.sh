#!/usr/bin/env sh

export RUBY_VERSION=2.3.3

# RVM installation ---------------------------------------------------
test -f '/usr/local/rvm/bin/rvm' || {
    curl -sSL 'https://get.rvm.io' | bash -s 'stable'
}

bash << RVM_INSTALL
. /etc/profile.d/rvm.sh
export BUNDLE_SILENCE_ROOT_WARNING=1

rvm use "${RUBY_VERSION}" || {
    rvm install "${RUBY_VERSION}"
    rvm use "${RUBY_VERSION}"
}

gem install --conservative    \
            --no-user-install \
            --no-post-install-message bundler
RVM_INSTALL

ln -sfv \
   "/usr/local/rvm/rubies/ruby-${RUBY_VERSION}/bin/ruby" \
   "/usr/local/bin/ruby$(echo ${RUBY_VERSION} | perl -pe 's#([0-9]+)\.([0-9]+)\.([0-9]+)$#$1.$2#')"
