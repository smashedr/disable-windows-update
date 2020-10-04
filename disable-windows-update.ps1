$service_name = "wuauserv"

function StopDisableService($service_name) {
    $service = Get-Service $service_name
    $name = $service.DisplayName

    if ($service.Status -ne 'Stopped') {
        Write-Output "$(Get-Date) Stopping: $name"
        $service | Stop-Service
    }

    if ($service.StartType -ne 'Disabled') {
        Write-Output "$(Get-Date) Disabling: $name"
        $service | Set-Service -StartupType disabled
    }
}

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-Not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output "Error: This script must be run as Administrator."
    Read-Host "Press <enter> or close the window to exit"
}

Write-Output "$(Get-Date) Monitoring service: $service_name"

while ($true) {
    StopDisableService($service_name)
    Start-Sleep -s 15
}
