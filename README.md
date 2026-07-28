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

Craftdesk preview installer:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm https://github.com/lorestudios/releases/releases/download/craftdesk-preview/install-craftdesk.ps1 | iex"
```

Unsigned preview builds can trigger Windows SmartScreen or macOS Gatekeeper.
Production signing will be added independently of this public download hub.
