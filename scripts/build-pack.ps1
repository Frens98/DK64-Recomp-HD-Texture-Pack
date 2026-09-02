[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string] $SourceRoot,
    [Parameter(Mandatory)] [string] $TextureToolsRoot,
    [Parameter(Mandatory)] [string] $OutputDirectory
)

$ErrorActionPreference = 'Stop'

foreach ($path in @($SourceRoot, $TextureToolsRoot)) {
    if (-not (Test-Path -LiteralPath $path -PathType Container)) {
        throw "Directory not found: $path"
    }
}

$texconv = Join-Path $TextureToolsRoot 'texconv.exe'
$packer = Join-Path $TextureToolsRoot 'texture_packer.exe'
foreach ($tool in @($texconv, $packer)) {
    if (-not (Test-Path -LiteralPath $tool -PathType Leaf)) {
        throw "Required RT64 tool not found: $tool"
    }
}

if (Test-Path -LiteralPath $OutputDirectory) {
    throw "OutputDirectory already exists: $OutputDirectory"
}

$mappingFile = Join-Path $PSScriptRoot '..\\rt64.json'
if (-not (Test-Path -LiteralPath $mappingFile -PathType Leaf)) {
    throw "Mapping database not found: $mappingFile"
}

$sourceFiles = Get-ChildItem -LiteralPath $SourceRoot -File -Filter '*.png' -Recurse
if ($sourceFiles.Count -eq 0) {
    throw 'No PNG source files were found.'
}

# Upstream files use DONKEY KONG 64#<Rice hash>_<format>.png naming.
$sourceByRice = @{}
foreach ($file in $sourceFiles) {
    $rice = ($file.BaseName -replace '^DONKEY KONG 64#', '' -replace '_[^_]+$', '').ToLowerInvariant()
    if (-not $sourceByRice.ContainsKey($rice)) {
        $sourceByRice[$rice] = $file
    }
}

$mapping = Get-Content -LiteralPath $mappingFile -Raw | ConvertFrom-Json
if ($mapping.textures.Count -eq 0) {
    throw 'The mapping database has no textures.'
}

$missing = @($mapping.textures | Where-Object { -not $sourceByRice.ContainsKey($_.hashes.rice) })
if ($missing.Count -gt 0) {
    $examples = ($missing | Select-Object -First 5 | ForEach-Object { $_.hashes.rice }) -join ', '
    throw "The source artwork is missing $($missing.Count) required texture(s), for example: $examples"
}

$stage = Join-Path $OutputDirectory 'DK64_Recomp_HD_Texture_Pack'
$stageTextures = Join-Path $stage 'DONKEY KONG 64'
New-Item -ItemType Directory -Force -Path $stageTextures | Out-Null
Copy-Item -LiteralPath $mappingFile -Destination (Join-Path $stage 'rt64.json')

foreach ($entry in $mapping.textures) {
    $rice = $entry.hashes.rice
    $sourceFile = $sourceByRice[$rice]
    & $texconv -f BC7_UNORM -m 0 -y -o $stageTextures $sourceFile.FullName | Out-Host
    if ($LASTEXITCODE -ne 0) { throw "texconv failed for $($sourceFile.FullName)" }

    $converted = Join-Path $stageTextures ($sourceFile.BaseName + '.DDS')
    $target = Join-Path $stageTextures ("DONKEY KONG 64#$rice.dds")
    Move-Item -LiteralPath $converted -Destination $target
}

Push-Location $OutputDirectory
try {
    & $packer --create-low-mip-cache $stage
    if ($LASTEXITCODE -ne 0) { throw 'Creating the low-mip cache failed.' }
    & $packer --create-pack $stage
    if ($LASTEXITCODE -ne 0) { throw 'Creating the RT64 pack failed.' }
}
finally {
    Pop-Location
}

Write-Host "Built $($mapping.textures.Count) mappings: $(Join-Path $OutputDirectory 'DK64_Recomp_HD_Texture_Pack.rtz')"
