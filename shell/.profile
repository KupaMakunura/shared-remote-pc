# Personal portable login-shell profile.

if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

export PATH

if [ -r "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi
