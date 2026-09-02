# DK64 Recomp HD Texture Pack

An RT64 HD texture pack for **Donkey Kong 64: Recompiled**.

<img width="985" height="742" alt="DK Island" src="https://github.com/user-attachments/assets/b5f76ece-a039-47e1-8862-7d7ccba8103e" />

Download **`DK64_Recomp_HD_Texture_Pack_0.3.2.rtz`** from the [latest release](../../releases/latest).

## Install

1. Download the `.rtz` file.
2. Copy it to `%LOCALAPPDATA%\DK64Recompiled\mods`.
3. Start or restart Recompiled.

## Current status

- 1,033 safe RT64 texture mappings.
- 1,036 of 1,061 legacy source identities were found in the final capture (97.6%).
- Capture used: 113,346 raw files and 26,856 runtime mappings.

This percentage describes matching coverage of the legacy source set, not a claim that every DK64 texture has been replaced. Three ambiguous hash collisions are intentionally excluded to avoid wrong textures.

## Repository contents

- [`rt64.json`](rt64.json) — the actual mapping database used by the release.
- [`scripts/build-pack.ps1`](scripts/build-pack.ps1) — reproducible RT64 build script.
- [`BUILD.md`](BUILD.md) — local build requirements and command.

The original PNG artwork is not included here. It is credited below and must be obtained separately under its original terms.

## Credits

Original HD texture artwork: [FullmetalHobbit's DK64 HD Texture Pack](https://gamebanana.com/mods/53808). Donkey Kong 64 and related trademarks are property of Nintendo and their respective owners. Unofficial fan project.
