FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      bash \
      bash-completion \
      coreutils \
      procps \
      psmisc \
      util-linux \
      iproute2 \
      iputils-ping \
      iputils-tracepath \
      traceroute \
      mtr-tiny \
      arping \
      ethtool \
      net-tools \
      bridge-utils \
      vlan \
      tcpdump \
      nmap \
      conntrack \
      nftables \
      iptables \
      ufw \
      ipset \
      curl \
      wget \
      netcat-openbsd \
      socat \
      iperf3 \
      dnsutils \
      bind9-host \
      openssh-client \
      openssh-server \
      python3 \
      python3-pip \
      python3-venv \
      less \
      tmux \
      mc \
      htop \
      nano \
      vim-tiny \
      jq \
      lsof \
      strace \
      sudo \
      && \
    if ! command -v unminimize >/dev/null 2>&1; then \
      apt-get install -y --no-install-recommends unminimize; \
    fi && \
    yes | unminimize && \
    apt-get install -y --no-install-recommends --reinstall man-db manpages && \
    mkdir -p /run/sshd && \
    sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo 'root:lab' | chpasswd && \
    sed -i 's/^IPV6=.*/IPV6=no/' /etc/default/ufw && \
    mandb -q && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cat >/etc/profile.d/lab-aliases.sh <<'EOF'
alias ll='ls -lah'
alias ipa='ip addr'
alias ipr='ip route'
alias ips='ip -br addr'
alias ports='ss -lntup'
alias routes='ip route show'
alias neigh='ip neigh show'
alias nftl='nft list ruleset'
alias ufws='ufw status numbered'
EOF

RUN cat >/etc/profile.d/99-disable-systemd-osc-context.sh <<'EOF'
# Disable systemd OSC 3008 prompt context for clients that render it visibly.
[ -n "${BASH_VERSION:-}" ] || return 0

unset PS0

if declare -p PROMPT_COMMAND 2>/dev/null | grep -q '^declare \-[^ ]*a'; then
  __new_prompt_command=()
  for __cmd in "${PROMPT_COMMAND[@]}"; do
    [ "$__cmd" = "__systemd_osc_context_precmdline" ] && continue
    __new_prompt_command+=("$__cmd")
  done
  PROMPT_COMMAND=("${__new_prompt_command[@]}")
  unset __new_prompt_command __cmd
else
  PROMPT_COMMAND="${PROMPT_COMMAND//__systemd_osc_context_precmdline;}"
  PROMPT_COMMAND="${PROMPT_COMMAND//;__systemd_osc_context_precmdline/}"
  PROMPT_COMMAND="${PROMPT_COMMAND//__systemd_osc_context_precmdline/}"
fi

unset -f __systemd_osc_context_escape \
  __systemd_osc_context_common \
  __systemd_osc_context_ps0 \
  __systemd_osc_context_precmdline 2>/dev/null || true
EOF

RUN cat >/etc/motd <<'EOF'
Networking lab node

Useful commands:
  ip -br addr
  ip route
  ip neigh
  ping <ip>
  traceroute <ip>
  ss -lntup
  tcpdump -ni <iface>
  ufw status numbered
  nft list ruleset
  python3 -m http.server 8080
EOF
