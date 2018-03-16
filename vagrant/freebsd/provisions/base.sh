#!/usr/bin/env sh

# minimal rbenv requirements -----------------------------------------
export PACKAGES='bash bash-completion'
# misc utils ---------------------------------------------------------
PACKAGES="${PACKAGES} htop pstree pidof curl vim-lite direnv"
# libgit2/rugged  ----------------------------------------------------
PACKAGES="${PACKAGES} cmake devel/pkgconf"

# packages installation ----------------------------------------------
pkg update
for i in $(echo $PACKAGES | perl -pe "s#\s+#\n#g" | sort -u); do
    printf "Installing %s\n" "$i"
    pkg install -Uy "$i"
done

# bash setup ---------------------------------------------------------
chsh -s '/usr/local/bin/bash' 'vagrant'
echo '. /etc/profile 2>/dev/null' > /home/vagrant/.profile
echo '. "${HOME}/.bashrc" 2>/dev/null' >> /home/vagrant/.profile
for i in /home/vagrant /root; do
    echo 'gem: --no-ri --no-rdoc' > "${i}/.gemrc"
done

chown -Rf 'vagrant:vagrant' '/home/vagrant'
rm -rf /home/*/*.iso
head -1 /etc/motd | tee /etc/motd
