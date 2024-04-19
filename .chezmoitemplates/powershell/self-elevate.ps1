function selfEvelate {
  # Self-elevate the script if required
  if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
      # you can remove -NoExit from $CommandLine, but then you likely won’t see the output of the elevated script, which will make it more difficult to determine if something went wrong during its execution.
      $CommandLine = "-NoExit -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
      Start-Process -Wait -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
      Exit
    }
  }
}

$selfElevate = [System.Environment]::GetEnvironmentVariable("SELF_ELEVATE", [System.EnvironmentVariableTarget]::User)

if($null -ne $selfElevate) {
  selfEvelate
}