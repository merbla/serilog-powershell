. .\serilog.ps1
cls
Write-Host "Playing Around"

# $test = 1..10 |%{ Write-Host "Number is $_" } | Select-WriteHost -Quiet |?{$_ -like "Number is 1*"}
# $test

$path = "C:\Code\serilog-powershell\lib\Serilog.dll"
$fullpath = "C:\Code\serilog-powershell\lib\Serilog.FullNetFx.dll"

[System.Reflection.Assembly]::LoadFile($path)
[System.Reflection.Assembly]::LoadFile($fullpath)


$config = New-Object -TypeName "Serilog.LoggerConfiguration"
#$read = $config.ReadFrom
$logPath = "C:\Temp\Test.log"

# public static Serilog.LoggerConfiguration File(this Serilog.Configuration.LoggerSinkConfiguration sinkConfiguration, 
#   string path, [Serilog.Events.LogEventLevel restrictedToMinimumLevel = Serilog.Events.LogEventLevel.Verbose], 
#   [string outputTemplate = "{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz} [{Level}] {Message}{NewLine}{Exception}"], 
#   [System.IFormatProvider formatProvider = null], [long? fileSizeLimitBytes = 1073741824])
$fileSize = 1073741824
$outputTemplate = "{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz} [{Level}] {Message}{NewLine}{Exception}"
[Serilog.LoggerConfigurationFullNetFxExtensions]::File($config.WriteTo, $logPath, [Serilog.Events.LogEventLevel]::Verbose, $outputTemplate, $null, $fileSize)


$anImportantMessage = "Something happened"

$anImportantMessage | ToSerilog

# $log = $config.CreateLogger()
# [Serilog.Log]::Logger = $log
# [Serilog.Log]::Information("Hello 2")
# [Serilog.Log]::Information("Hello 2")
# [Serilog.Log]::Information("Hello 2")
# [Serilog.Log]::Information("Hello 2")
# [Serilog.Log]::Information("Hello 2")
# [Serilog.Log]::Information("Hello 2")
# [Serilog.Log]::Information("Hello 2")
# [Serilog.Log]::Information("Hello 2")
# [Serilog.Log]::Information("Hello 2")
# [Serilog.Log]::Information("Hello 2")
# [Serilog.Log]::Information("Hello 2")
# [Serilog.Log]::Information("Hello 2")
# [Serilog.Log]::Information("Hello 2")
# [Serilog.Log]::Information("Hello 2")


# $log.Dispose()
