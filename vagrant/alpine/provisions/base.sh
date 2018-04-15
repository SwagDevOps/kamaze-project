#!/usr/bin/env sh

set -e

# @see https://github.com/nicdoye/alpine-rvm-gcc/blob/master/Dockerfile
# requirements -------------------------------------------------------
export PACKAGES
PACKAGES="${PACKAGES} bash bash-completion sed tar shadow"
PACKAGES="${PACKAGES} htop pstree curl vim"
PACKAGES="${PACKAGES} gcc gnupg curl ruby bash procps musl-dev make"
PACKAGES="${PACKAGES} linux-headers zlib zlib-dev ruby-dev"
PACKAGES="${PACKAGES} openssl openssl-dev libssl1.0"
# libgit2/rugged  ----------------------------------------------------
PACKAGES="${PACKAGES} cmake pkgconf"

# packages installation ----------------------------------------------
apk update
for i in $(echo $PACKAGES | sed -e "s#\s\+#\n#g" | sort -u); do
    printf "Installing %s...\n" "$i"
    apk add "$i"
done

# bash setup ---------------------------------------------------------
echo '. /etc/profile 2>/dev/null' > /home/vagrant/.profile
echo '. "${HOME}/.bashrc" 2>/dev/null' >> /home/vagrant/.profile
for i in /home/vagrant /root; do
    echo 'gem: --no-ri --no-rdoc' > "${i}/.gemrc"
done

# permissions + misc  ------------------------------------------------
chown -Rf 'vagrant:vagrant' '/home/vagrant'
rm -rf /home/*/*.iso
chmod o+r /proc/devices

head -1 /etc/motd | tee /etc/motd
sed -i 's#\. $script#. $script 2> /dev/null#g' /etc/profile
