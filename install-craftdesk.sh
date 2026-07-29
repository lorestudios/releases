#!/usr/bin/env bash
set -euo pipefail

RELEASE_BASE=${CRAFTDESK_PREVIEW_RELEASE_BASE:-https://github.com/lorestudios/releases/releases/download/craftdesk-preview}
MAX_DOWNLOAD_BYTES=67108864

command -v curl >/dev/null 2>&1 || {
  echo "curl is required to install Craftdesk." >&2
  exit 1
}

transaction=$(mktemp -d "${TMPDIR:-/tmp}/craftdesk-preview-install.XXXXXX")
cleanup() {
  rm -rf "$transaction"
}
trap cleanup EXIT HUP INT TERM

download() {
  local url=$1
  local destination=$2
  local effective
  effective=$(
    curl --proto '=https' --proto-redir '=https' \
      --location --max-redirs 5 \
      --connect-timeout 5 --max-time 120 \
      --fail --silent --show-error \
      --output "$destination" \
      --write-out '%{url_effective}' \
      "$url"
  )
  case "$effective" in
    https://github.com/*|https://objects.githubusercontent.com/*|https://release-assets.githubusercontent.com/*) ;;
    *)
      echo "Craftdesk download redirected to an untrusted host." >&2
      exit 1
      ;;
  esac
  local size
  size=$(wc -c <"$destination" | tr -d '[:space:]')
  case "$size" in
    ''|*[!0-9]*)
      echo "Craftdesk download size is invalid." >&2
      exit 1
      ;;
  esac
  if [ "$size" -le 0 ] || [ "$size" -gt "$MAX_DOWNLOAD_BYTES" ]; then
    echo "Craftdesk download size is outside the allowed range." >&2
    exit 1
  fi
}

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    setup="$transaction/craftdesk-setup-windows-amd64.exe"
    download \
      "$RELEASE_BASE/craftdesk-setup-windows-amd64.exe" \
      "$setup"
    chmod u+x "$setup"
    MSYS2_ARG_CONV_EXCL='*' "$setup" /install "$@"
    ;;

  Darwin)
    case "$(uname -m)" in
      arm64) platform=darwin-arm64 ;;
      x86_64) platform=darwin-amd64 ;;
      *)
        echo "Craftdesk does not provide a preview for this macOS architecture." >&2
        exit 1
        ;;
    esac
    archive="$transaction/craftdesk-$platform.tar.gz"
    download "$RELEASE_BASE/craftdesk-$platform.tar.gz" "$archive"

    entries=$(
      tar -tzf "$archive" |
        LC_ALL=C sort
    )
    expected=$(printf '%s\n' LICENSE craftd craftdesk craftsesh | LC_ALL=C sort)
    if [ "$entries" != "$expected" ]; then
      echo "Craftdesk preview archive has unexpected contents." >&2
      exit 1
    fi

    install_root="$HOME/Library/Application Support/Craftdesk/preview"
    stage="$install_root/.stage-$$"
    destination="$install_root/bin"
    backup="$install_root/.rollback"
    mkdir -p "$install_root"
    rm -rf "$stage"
    mkdir -m 700 "$stage"
    tar -xzf "$archive" -C "$stage"
    chmod 700 "$stage/craftdesk" "$stage/craftd" "$stage/craftsesh"
    "$stage/craftdesk" --self-test
    "$stage/craftd" --self-test
    "$stage/craftsesh" --self-test

    rm -rf "$backup"
    if [ -d "$destination" ]; then
      mv "$destination" "$backup"
    fi
    if ! mv "$stage" "$destination"; then
      if [ -d "$backup" ]; then
        mv "$backup" "$destination"
      fi
      exit 1
    fi
    rm -rf "$backup"

    mkdir -p "$HOME/.local/bin"
    ln -sfn "$destination/craftdesk" "$HOME/.local/bin/craftdesk"
    ln -sfn "$destination/craftd" "$HOME/.local/bin/craftd"
    ln -sfn "$destination/craftsesh" "$HOME/.local/bin/craftsesh"

    case "${SHELL:-}" in
      */bash) profile="$HOME/.bash_profile" ;;
      *) profile="$HOME/.zprofile" ;;
    esac
    path_line='export PATH="$HOME/.local/bin:$PATH"'
    if [ ! -f "$profile" ] || ! grep -Fqx "$path_line" "$profile"; then
      printf '\n%s\n' "$path_line" >>"$profile"
    fi
    printf '%s\n' \
      "Craftdesk preview installed." \
      "Open a new terminal and run: craftdesk"
    ;;

  *)
    echo "Craftdesk preview supports Windows Git Bash and macOS." >&2
    exit 1
    ;;
esac
