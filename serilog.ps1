function ToSerilogFile
{
   [CmdletBinding(DefaultParameterSetName = 'FromPipeline')]
   param(
     [Parameter(ValueFromPipeline = $true, ParameterSetName = 'FromPipeline')]
     [object] $InputObject,
    [Parameter(ValueFromPipeline = $false, Mandatory = $true)]
     [string] $logPath
   )
 
   begin
   {  
      
      Write-Verbose "Playing Around with PowerShell and Serilog to a file"

      function LoadSerilog{
        $path = "C:\Code\serilog-powershell\lib\Serilog.dll"
        $fullpath = "C:\Code\serilog-powershell\lib\Serilog.FullNetFx.dll"

        [System.Reflection.Assembly]::LoadFile($path)
        [System.Reflection.Assembly]::LoadFile($fullpath)

        $config = New-Object -TypeName "Serilog.LoggerConfiguration"
         
        $fileSize = 1073741824
        $outputTemplate = "{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz} [{Level}] {Message}{NewLine}{Exception}"
        [Serilog.LoggerConfigurationFullNetFxExtensions]::File($config.WriteTo, $logPath, [Serilog.Events.LogEventLevel]::Verbose, $outputTemplate, $null, $fileSize)

        $log = $config.CreateLogger()
        [Serilog.Log]::Logger = $log

        return $log
      }

      function Cleanup {
        $oldLog = [Serilog.Log]::Logger 
        $oldLog.Dispose()
      } 

     $log = LoadSerilog
  
   }
 
  process{
        [Serilog.Log]::Information("{0}", $InputObject)
  }
  end { 
    Cleanup 
  } 
}

function ToSerilog
{
   [CmdletBinding(DefaultParameterSetName = 'FromPipeline')]
   param(
     [Parameter(ValueFromPipeline = $true, ParameterSetName = 'FromPipeline')]
     [object] $InputObject
   )
 
   begin
   {  
      
      Write-Verbose "Playing Around with PowerShell and Serilog"

      function LoadSerilog{
        $path = "C:\Code\serilog-powershell\lib\Serilog.dll"
        $fullpath = "C:\Code\serilog-powershell\lib\Serilog.FullNetFx.dll"

        [System.Reflection.Assembly]::LoadFile($path)
        [System.Reflection.Assembly]::LoadFile($fullpath)

        $config = New-Object -TypeName "Serilog.LoggerConfiguration"
        #$read = $config.ReadFrom
        $logPath = "C:\Temp\Serilog.log"

        # public static Serilog.LoggerConfiguration File(this Serilog.Configuration.LoggerSinkConfiguration sinkConfiguration, 
        #   string path, [Serilog.Events.LogEventLevel restrictedToMinimumLevel = Serilog.Events.LogEventLevel.Verbose], 
        #   [string outputTemplate = "{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz} [{Level}] {Message}{NewLine}{Exception}"], 
        #   [System.IFormatProvider formatProvider = null], [long? fileSizeLimitBytes = 1073741824])
        $fileSize = 1073741824
        $outputTemplate = "{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz} [{Level}] {Message}{NewLine}{Exception}"
        [Serilog.LoggerConfigurationFullNetFxExtensions]::File($config.WriteTo, $logPath, [Serilog.Events.LogEventLevel]::Verbose, $outputTemplate, $null, $fileSize)


        $log = $config.CreateLogger()
        [Serilog.Log]::Logger = $log

        return $log
      }

      function Cleanup {
        $oldLog = [Serilog.Log]::Logger 
        $oldLog.Dispose()
      }

    function Log {
       param($log, $data)

       $log.Information("{0}", $data)
      
    }
     
     $log = LoadSerilog
  
   }
 
   process
   {
        [Serilog.Log]::Information("{0}", $InputObject)

   }
 
   end
   {

      Cleanup $log
   }  
}