# Lore Studios Releases

Public binary releases and installers for Lore Studios products.

Source code is maintained in separate private repositories. This repository
contains public installer entry points and release metadata; product binaries
are attached to GitHub Releases.

## Release naming

Each product owns its own tags so releases cannot collide:

- `<product>-preview` is the rolling manual-test release.
- `<product>-stable` is the rolling production installer endpoint.
- `<product>-v<version>` is an immutable versioned release.

## Craftdesk preview

Git Bash on Windows or macOS Terminal:

```bash
curl -fsSL https://github.com/lorestudios/releases/releases/download/craftdesk-preview/install-craftdesk.sh | bash
```

Windows PowerShell:

```powershell
irm https://github.com/lorestudios/releases/releases/download/craftdesk-preview/install-craftdesk.ps1 | iex
```

Windows CMD:

```bat
curl -fsSL https://github.com/lorestudios/releases/releases/download/craftdesk-preview/install-craftdesk.cmd -o install-craftdesk.cmd && install-craftdesk.cmd && del install-craftdesk.cmd
```

Open a new terminal after installation and run:

```bash
craftdesk
```

The short scripts bootstrap the native installer. Windows users can
alternatively download and run the self-contained
[Craftdesk Windows installer](https://github.com/lorestudios/releases/releases/download/craftdesk-preview/craftdesk-setup-windows-amd64.exe).

Unsigned preview builds can trigger Windows SmartScreen or macOS Gatekeeper.
Production signing will be added independently of this public download hub.
