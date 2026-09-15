# shared-remote-pc

Personal Linux setup and configuration repository for rebuilding this environment on another PC.

## Install on a target Linux machine

Copy or clone this repository to the target machine and run:

```sh
cd shared-remote-pc
bash install.sh --install-system-packages
```

Use `bash install.sh --help` to see the available options. The installer:

- installs missing base packages when the Linux package manager is supported;
- installs Oh My Zsh and the two configured Zsh plugins;
- installs the portable Zsh configuration as `~/.zshrc`;
- installs the login profile, local-bin environment helper, and Git configuration;
- installs Codex preferences to `~/.codex/config.toml`;
- installs the bundled Codex skills, custom agents, and rules;
- installs the separately managed `~/.agents/skills` collection and its lockfile;
- backs up existing configuration files before replacing them.

Codex itself is not bundled as a binary. Install the Codex CLI or desktop app on the target machine, sign in there, then run this installer. Authentication is intentionally kept out of this repository.

## Repository layout

```text
zsh/.zshrc              Zsh, Oh My Zsh, plugins, NVM, Bun, pnpm, Android paths
shell/.profile          Portable login-shell profile
shell/local-bin-env     User-local PATH helper
git/.gitconfig           Git identity and GitHub credential-helper setup
codex/config.toml       Portable Codex preferences and Context7 MCP configuration
codex/skills/           User Codex skills
codex/agents/           Custom Codex subagent definitions
codex/rules/            Codex command approval rules
agents/skills/          Additional personal agent skills
agents/skill-lock.json  Sources and versions for additional agent skills
install.sh              Target-machine installer
```

## Intentionally excluded

Credentials, `~/.codex/auth.json`, histories, logs, SQLite databases, caches, IPC files, generated images, absolute project trust paths, app-managed plugin runtime paths, and the npm token file are not portable and are not included.

The Zsh configuration detects NVM, Bun, pnpm, and Android SDK installations if they exist. Those tools are installed separately because their binaries are OS-, architecture-, and version-specific.
