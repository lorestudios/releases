# Lore Studios Releases

Public binary releases and installers for Lore Studios products.

Source code is maintained in separate private repositories. This repository
contains release metadata only; product binaries are attached to GitHub
Releases.

## Release naming

Each product owns its own tags so releases cannot collide:

- `<product>-preview` is the rolling manual-test release.
- `<product>-stable` is the rolling production installer endpoint.
- `<product>-v<version>` is an immutable versioned release.

## Craftdesk preview

### Windows

Download and run the self-contained
[Craftdesk Windows installer](https://github.com/lorestudios/releases/releases/download/craftdesk-preview/craftdesk-setup-windows-amd64.exe).

From Git Bash, the equivalent direct EXE command is:

```bash
curl -fL -o craftdesk-setup.exe https://github.com/lorestudios/releases/releases/download/craftdesk-preview/craftdesk-setup-windows-amd64.exe &&
./craftdesk-setup.exe
```

The executable contains the complete Craftdesk bundle, installs it for the
current user, runs native health checks, and adds Craftdesk to the user PATH.
It does not invoke Bash or PowerShell during installation.

### macOS

Download the archive for
[Intel](https://github.com/lorestudios/releases/releases/download/craftdesk-preview/craftdesk-darwin-amd64.tar.gz)
or
[Apple Silicon](https://github.com/lorestudios/releases/releases/download/craftdesk-preview/craftdesk-darwin-arm64.tar.gz).

Unsigned preview builds can trigger Windows SmartScreen or macOS Gatekeeper.
Production signing will be added independently of this public download hub.
