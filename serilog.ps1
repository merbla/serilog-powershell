


function Select-WriteHost
{
   [CmdletBinding(DefaultParameterSetName = 'FromPipeline')]
   param(
     [Parameter(ValueFromPipeline = $true, ParameterSetName = 'FromPipeline')]
     [object] $InputObject,
 
     [Parameter(Mandatory = $true, ParameterSetName = 'FromScriptblock', Position = 0)]
     [ScriptBlock] $ScriptBlock,
 
     [switch] $Quiet
   )
 
   begin
   {
     function Cleanup
     {
       # clear out our proxy version of write-host
       remove-item function:write-host -ea 0
     }
 
     function ReplaceWriteHost([switch] $Quiet, [string] $Scope)
     {
         # create a proxy for write-host
         $metaData = New-Object System.Management.Automation.CommandMetaData (Get-Command 'Microsoft.PowerShell.Utility\Write-Host')
         $proxy = [System.Management.Automation.ProxyCommand]::create($metaData)
 
         # change its behavior
         $content = if($quiet)
                    {
                       # in quiet mode, whack the entire function body, simply pass input directly to the pipeline
                       $proxy -replace '(?s)\bbegin\b.+', '$Object'
                    }
                    else
                    {
                       # in noisy mode, pass input to the pipeline, but allow real write-host to process as well
                       $proxy -replace '($steppablePipeline.Process)', '$Object; $1'
                    }  
 
         # load our version into the specified scope
         Invoke-Expression "function ${scope}:Write-Host { $content }"
     }

     function LoadSerilog{

        $scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
        $serilogFilePath = "\lib\Serilog.dll"
        $path = "C:\Code\serilog-powershell\lib\Serilog.dll"
        echo $path

        [System.Reflection.Assembly]::LoadFile($path)

    #var log = new LoggerConfiguration()
        #.WriteTo.File("log.txt")
        #.CreateLogger();



    }

    function Log {
      
    }

     Cleanup
     LoadSerilog
 
     # if we are running at the end of a pipeline, need to immediately inject our version
     #    into global scope, so that everybody else in the pipeline uses it.
     #    This works great, but dangerous if we don't clean up properly.
     if($pscmdlet.ParameterSetName -eq 'FromPipeline')
     {
        ReplaceWriteHost -Quiet:$quiet -Scope 'global'
     }
   }
 
   process
   {
      # if a scriptblock was passed to us, then we can declare
      #   our version as local scope and let the runtime take it out
      #   of scope for us.  Much safer, but it won't work in the pipeline scenario.
      #   The scriptblock will inherit our version automatically as it's in a child scope.
      if($pscmdlet.ParameterSetName -eq 'FromScriptBlock')
      {
        . ReplaceWriteHost -Quiet:$quiet -Scope 'local'
        & $scriptblock
      }
      else
      {

        Log - $InputObject

         # in pipeline scenario, just pass input along
         $InputObject
      }
   }
 
   end
   {
      Cleanup
   }  
}