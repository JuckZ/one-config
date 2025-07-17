# 管理员权限检查函数
function Ensure-RunAsAdministrator {
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "⚠️ 当前未以管理员身份运行，正在尝试提升权限..." -ForegroundColor Yellow
        $script = $MyInvocation.MyCommand.Definition
        $args = $MyInvocation.UnboundArguments
        Start-Process powershell -Verb runAs -ArgumentList "-ExecutionPolicy Bypass -File `"$script`" $args"
        Exit
    }
}

# 调用管理员权限检查
Ensure-RunAsAdministrator

# 多网络配置
$networkProfiles = @{
    "家庭WiFi" = @{
        InterfaceName = "WLAN"
        StaticIP = "192.168.31.145"
        PrefixLength = 24
        Gateway = "192.168.31.1"
        DnsServers = @("192.168.31.110", "192.168.31.1")
    }
    "公司有线" = @{
        InterfaceName = "以太网"
        StaticIP = "10.0.0.100"
        PrefixLength = 24
        Gateway = "10.0.0.1"
        DnsServers = @("8.8.8.8", "8.8.4.4")
    }
}

# 选择网络配置
Write-Host "请选择要配置的网络："
$profileNames = $networkProfiles.Keys
for ($i=0; $i -lt $profileNames.Count; $i++) {
    Write-Host "$($i+1). $($profileNames[$i])"
}
$profileChoice = Read-Host "请输入数字选择网络"
if ($profileChoice -match '^[0-9]+$' -and $profileChoice -ge 1 -and $profileChoice -le $profileNames.Count) {
    $selectedProfile = $networkProfiles[$profileNames[$profileChoice-1]]
} else {
    Write-Host "❌ 无效输入，脚本退出。" -ForegroundColor Red
    exit
}

$interfaceName = $selectedProfile.InterfaceName
$staticIP = $selectedProfile.StaticIP
$prefixLength = $selectedProfile.PrefixLength
$gateway = $selectedProfile.Gateway
$dnsServers = $selectedProfile.DnsServers

Write-Host "请选择网络配置模式："
Write-Host "1. 切换为 DHCP（自动获取 IP）"
Write-Host "2. 切换为静态 IP"
$choice = Read-Host "请输入数字 1 或 2"

if ($choice -eq "1") {
    Write-Host "`n正在切换为 DHCP..." -ForegroundColor Cyan
    Set-NetIPInterface -InterfaceAlias $interfaceName -Dhcp Enabled -ErrorAction Stop
    Set-DnsClientServerAddress -InterfaceAlias $interfaceName -ResetServerAddresses -ErrorAction Stop
    Write-Host "✅ 已成功切换为 DHCP 模式。" -ForegroundColor Green
}
elseif ($choice -eq "2") {
    Write-Host "`n正在配置静态 IP..." -ForegroundColor Cyan
    # 删除现有 IP（避免重复）
    Get-NetIPAddress -InterfaceAlias $interfaceName -AddressFamily IPv4 | Remove-NetIPAddress -Confirm:$false
    # 添加静态 IP
    New-NetIPAddress -InterfaceAlias $interfaceName -IPAddress $staticIP -PrefixLength $prefixLength -DefaultGateway $gateway -ErrorAction Stop
    # 设置 DNS
    Set-DnsClientServerAddress -InterfaceAlias $interfaceName -ServerAddresses $dnsServers -ErrorAction Stop
    Write-Host "✅ 已成功配置静态 IP。" -ForegroundColor Green
}
else {
    Write-Host "❌ 无效输入，请输入 1 或 2。" -ForegroundColor Red
}
