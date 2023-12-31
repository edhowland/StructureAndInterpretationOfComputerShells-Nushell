#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y pkg-config libssl-dev jq tree vim curl less elinks sqlite3

cd /usr/local/bin/
elinks --dump https://github.com/nushell/nushell/releases |
  grep -m1 -o https:.*x86_64-unknown-linux-gnu.tar.gz |
  xargs curl -Ls |
  sudo tar -xzf -
sudo ln -snf ./nu-*-unknown-linux-gnu/nu
yes | nu >& /dev/null || true


cat <<'eof' | sudo tee /usr/local/bin/nushell > /dev/null
#!/usr/bin/env bash
cat > /tmp/nushell.tmp.nu
nu --config ${HOME}/.config/nushell/config.nu /tmp/nushell.tmp.nu
eof
sudo chmod +x /usr/local/bin/nushell

