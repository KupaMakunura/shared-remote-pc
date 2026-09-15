#!/usr/bin/env bash
set -Eeuo pipefail

repo_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
install_packages=false
install_zsh=true
install_codex=true
install_shell=true
install_zed=true

usage() {
  cat <<'EOF'
Usage: bash install.sh [options]

Install this personal Linux environment onto the current user's home directory.

Options:
  --install-system-packages  Install missing zsh, git, and curl packages.
  --skip-zsh                 Do not install Oh My Zsh or ~/.zshrc.
  --skip-codex               Do not install Codex files.
  --skip-shell               Do not install ~/.profile, ~/.gitconfig, or ~/.local/bin/env.
  --skip-zed                 Do not install Zed settings.
  -h, --help                Show this help.
EOF
}

for arg in "$@"; do
  case "$arg" in
    --install-system-packages) install_packages=true ;;
    --skip-zsh) install_zsh=false ;;
    --skip-codex) install_codex=false ;;
    --skip-shell) install_shell=false ;;
    --skip-zed) install_zed=false ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This installer currently supports Linux only." >&2
  exit 1
fi

if [[ "$EUID" -eq 0 ]]; then
  echo "Run this installer as the target user, not with sudo. It writes to that user's home directory." >&2
  exit 1
fi

require_or_install_packages() {
  local missing=()
  local command_name

  for command_name in "$@"; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
      missing+=("$command_name")
    fi
  done

  if ((${#missing[@]} == 0)); then
    return
  fi

  if [[ "$install_packages" != true ]]; then
    echo "Missing commands: ${missing[*]}" >&2
    echo "Re-run with --install-system-packages, or install them manually." >&2
    exit 1
  fi

  if ! command -v sudo >/dev/null 2>&1; then
    echo "sudo is required to install system packages." >&2
    exit 1
  fi

  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y zsh git curl
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y zsh git curl
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --needed --noconfirm zsh git curl
  else
    echo "Unsupported package manager. Install zsh, git, and curl manually." >&2
    exit 1
  fi
}

backup_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    local backup="${file}.backup.$(date +%Y%m%d%H%M%S)"
    cp -p "$file" "$backup"
    echo "Backed up $file to $backup"
  fi
}

install_oh_my_zsh() {
  local zsh_dir="$HOME/.oh-my-zsh"
  local custom_dir="$zsh_dir/custom"

  if [[ ! -f "$zsh_dir/oh-my-zsh.sh" ]]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  mkdir -p "$custom_dir/plugins"

  if [[ ! -d "$custom_dir/plugins/zsh-autosuggestions" ]]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$custom_dir/plugins/zsh-autosuggestions"
  fi

  if [[ ! -d "$custom_dir/plugins/zsh-syntax-highlighting" ]]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom_dir/plugins/zsh-syntax-highlighting"
  fi

  backup_file "$HOME/.zshrc"
  cp -p "$repo_dir/zsh/.zshrc" "$HOME/.zshrc"
  echo "Installed Zsh configuration."
}

install_codex_files() {
  local codex_home="${CODEX_HOME:-$HOME/.codex}"

  mkdir -p "$codex_home/agents" "$codex_home/rules" "$codex_home/skills"
  backup_file "$codex_home/config.toml"
  cp -p "$repo_dir/codex/config.toml" "$codex_home/config.toml"
  cp -a "$repo_dir/codex/agents/." "$codex_home/agents/"
  cp -a "$repo_dir/codex/rules/." "$codex_home/rules/"
  cp -a "$repo_dir/codex/skills/." "$codex_home/skills/"
  echo "Installed Codex preferences, skills, agents, and rules to $codex_home."
  echo "Codex authentication remains local to this machine."
}

install_agent_skills() {
  local agents_home="${AGENTS_HOME:-$HOME/.agents}"

  mkdir -p "$agents_home/skills"
  cp -a "$repo_dir/agents/skills/." "$agents_home/skills/"
  cp -p "$repo_dir/agents/skill-lock.json" "$agents_home/skill-lock.json"
  echo "Installed additional agent skills to $agents_home/skills."
}

install_shell_files() {
  mkdir -p "$HOME/.local/bin"
  backup_file "$HOME/.profile"
  backup_file "$HOME/.gitconfig"
  backup_file "$HOME/.local/bin/env"
  cp -p "$repo_dir/shell/.profile" "$HOME/.profile"
  cp -p "$repo_dir/git/.gitconfig" "$HOME/.gitconfig"
  cp -p "$repo_dir/shell/local-bin-env" "$HOME/.local/bin/env"
  chmod 755 "$HOME/.local/bin/env"
  echo "Installed login profile, Git configuration, and local-bin environment helper."
}

install_zed_files() {
  local zed_home="${ZED_HOME:-$HOME/.config/zed}"

  mkdir -p "$zed_home"
  backup_file "$zed_home/settings.json"
  cp -p "$repo_dir/zed/settings.json" "$zed_home/settings.json"
  echo "Installed Zed settings to $zed_home/settings.json."
  echo "Zed credentials remain local to this machine."
}

if [[ "$install_zsh" == true ]]; then
  require_or_install_packages zsh git curl
  install_oh_my_zsh
fi

if [[ "$install_shell" == true ]]; then
  install_shell_files
fi

if [[ "$install_zed" == true ]]; then
  install_zed_files
fi

if [[ "$install_codex" == true ]]; then
  install_codex_files
  install_agent_skills
fi

echo
echo "Setup complete for user: $USER"
echo "Open a new terminal, or run: exec zsh"
echo "Optional: make Zsh your login shell with: chsh -s \"$(command -v zsh 2>/dev/null || echo /usr/bin/zsh)\""
