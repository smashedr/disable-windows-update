$ErrorActionPreference = "Stop"

## Compile Application
$source_file = "disable-windows-update.ps1"
$output_file = ".\bin\disable-windows-update.exe"
$application_name = "Disable Windows Update"
$author_name = "Shane"
$icon_file = ".\assets\updater.ico"

if (-Not $args[0]) {
    Write-Output "Specify version number in format x.x.x.x for argument one."
    exit
}
$version = $args[0]

if (Test-Path $output_file) {
    Remove-Item -Force $output_file
}

.\src\ps2exe.ps1 `
    -inputFile $source_file `
    -outputFile $output_file `
    -iconFile $icon_file `
    -title $application_name `
    -description $application_name `
    -product $application_name `
    -company $author_name `
    -copyright $author_name `
    -version $version `
    -requireAdmin

## Compile Installer
$source_file = "install.ps1"
$output_file = ".\install.exe"
$application_name = "Install Disable Windows Update"
$author_name = "Shane"
$icon_file = ".\assets\installer.ico"

if (-Not $args[0]) {
    Write-Output "Specify version number in format x.x.x.x for argument one."
    exit
}
$version = $args[0]

if (Test-Path $output_file) {
    Remove-Item -Force $output_file
}

.\src\ps2exe.ps1 `
    -inputFile $source_file `
    -outputFile $output_file `
    -iconFile $icon_file `
    -title $application_name `
    -description $application_name `
    -product $application_name `
    -company $author_name `
    -copyright $author_name `
    -version $version `
    -requireAdmin

## Package Installer & Application
$bin_path = ".\bin"
$installer_path = "install.exe"
$output_file = "disable-windows-update.zip"

if (Test-Path $output_file) {
    Remove-Item -Force $output_file
}

try {
    $compress = @{
        LiteralPath = $bin_path, $installer_path
        CompressionLevel = "Optimal"
        DestinationPath = $output_file
    }
    Compress-Archive @compress
} catch {
    Write-Output "Error creating archive: $output_file"
    ExitScript
}
