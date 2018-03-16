#!/usr/bin/env sh

# bundle install -----------------------------------------------------
/usr/bin/env bash << BUNDLE_INSTALL
set -e
. /etc/profile.d/rvm.sh
cd /vagrant

bundle install
chown -Rf 'vagrant:vagrant' vendor/*
BUNDLE_INSTALL
