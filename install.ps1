$ErrorActionPreference = "Stop"

$service_name = "disablewinup"
$install_name = "disable-windows-update.exe"
$install_path = Join-Path -Path ${Env:LOCALAPPDATA} -ChildPath "disable-windows-update"

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-Not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output "Error: This script must be run as Administrator."
    Read-Host "Press <enter> or close the window to exit"
}

if (Test-Path $install_path) {
    Write-Output "Removing and re-creating install directory: $install_path"
    Remove-Item -Recurse -Force -Path $install_path
    $install_dir = New-Item -Force -Path "$install_path" -ItemType "directory"
} else {
    Write-Output "Creating install directory: $install_path"
    $install_dir = New-Item -Force -Path "$install_path" -ItemType "directory"
}

Write-Output "Installing bin to directory: $install_path"
Copy-Item -Force -Path ".\bin\*" -Destination $install_dir
$app_exe_path = Join-Path -Path $install_dir -ChildPath $install_name
Unblock-File -Path $app_exe_path
$nssm = Join-Path -Path $install_dir -ChildPath "nssm.exe"
Unblock-File -Path $nssm

$log_file = Join-Path -Path $install_dir -ChildPath "log.txt"

Write-Output "Installing service: $service_name"
Start-Process -FilePath "$nssm" -ArgumentList "install $service_name $app_exe_path"
Start-Process -FilePath "$nssm" -ArgumentList "set $service_name AppDirectory $install_path"
Start-Process -FilePath "$nssm" -ArgumentList "set $service_name AppStdout $log_file"
Start-Process -FilePath "$nssm" -ArgumentList "set $service_name AppStderr $log_file"
Start-Process -FilePath "$nssm" -ArgumentList "set $service_name DisplayName Disable Windows Update"
Start-Process -FilePath "$nssm" -ArgumentList "set $service_name Description Stops and Disable the Windows Update Service."

Write-Output "Starting service: $service_name"
Start-Process -FilePath "$nssm" -ArgumentList "start $service_name"

Write-Output "Success! Done installing service: $service_name"
Read-Host "Press <enter> or close this window to exit"
