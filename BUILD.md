# Building the texture pack

The repository contains the RT64 mapping database and build script, but not the original PNG artwork or a game ROM.

You need a local, authorised copy of the original PNG source artwork and the RT64 Texture Pack Tools (`texconv.exe` and `texture_packer.exe`).

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build-pack.ps1 `
  -SourceRoot "D:\\DK64-HD-source" `
  -TextureToolsRoot "D:\\rt64-tools" `
  -OutputDirectory "D:\\DK64-build"
```

The script uses this repository's reviewed mapping database, converts the artwork to DDS, creates a low-mip cache, and packages an `.rtz` file. Known Rice-hash collisions remain excluded deliberately.

RT64's texture-pack format and tools are documented in the [official RT64 texture-pack documentation](https://github.com/rt64/rt64/blob/main/TEXTURE-PACKS.md).
