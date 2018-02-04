Configuration Main
{
	Param ([string]$nodeName,
		$Office,
		$Os)
	
	Import-DscResource -ModuleName PsDesiredStateConfiguration, xComputerManagement
	
	Node $nodeName
	
	{
		LocalConfigurationManager
		{
			RebootNodeIfNeeded = $true
			ConfigurationMode = "ApplyOnly"
		}
		WindowsFeature RDS-RD-Server
		{
			Ensure = "Present"
			Name = "RDS-RD-Server"
		}
		
		WindowsFeature NET-Framework-Core
		{
			Ensure = "Present"
			Name = "NET-Framework-Core"
			DependsOn = '[WindowsFeature]RDS-RD-Server'
		}
		
		WindowsFeature NET-Framework-Features
		{
			Ensure = "Present"
			Name = "NET-Framework-Features"
			DependsOn = '[WindowsFeature]NET-Framework-Core'
		}
		
		WindowsFeature Telnet-Client
		{
			Ensure = "Present"
			Name = "Telnet-Client"
			DependsOn = '[WindowsFeature]NET-Framework-Features'
		}
		
		if ($Os -Like "2016-Datacenter")
		{
			
			WindowsFeature WebDAV-Redirector
			{
				Ensure = "Present"
				Name = "WebDAV-Redirector"
				DependsOn = '[WindowsFeature]Telnet-Client'
			}
			
		}
		
		WindowsFeature Print-Server
		{
			Ensure = "Present"
			Name = "Print-Server"
			DependsOn = '[WindowsFeature]Telnet-Client'
		}
		
		
		if ($Office -eq "yes")
		{
			Package "Microsoft Office 365 ProPlus Installer"
			{
				Name = "Microsoft Office 365 ProPlus Installer"
				Path = "\\xxxx.xxxx.xxxx\Build$\OfficeProPlus.msi"
				Ensure    = "Present"
				ProductID = '{5249E795-8BA2-4097-99E3-C722DBA96338}'
				ReturnCode = 0
				DependsOn = '[WindowsFeature]Print-Server'
			}
		}
		Registry RdmsEnableUILog
		{
			Ensure = "Present"
			Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDMS"
			ValueName = "EnableUILog"
			ValueType = "Dword"
			ValueData = "1"
		}
		
		Registry EnableDeploymentUILog
		{
			Ensure = "Present"
			Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDMS"
			ValueName = "EnableDeploymentUILog"
			ValueType = "Dword"
			ValueData = "1"
		}
		
		Registry EnableTraceLog
		{
			Ensure = "Present"
			Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDMS"
			ValueName = "EnableTraceLog"
			ValueType = "Dword"
			ValueData = "1"
		}
		
		Registry EnableTraceToFile
		{
			Ensure = "Present"
			Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDMS"
			ValueName = "EnableTraceToFile"
			ValueType = "Dword"
			ValueData = "1"
		}
		
	}
}
