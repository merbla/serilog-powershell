#region

using System.Management.Automation;

#endregion

namespace Serilog.PowerShell
{
    [Cmdlet(VerbsCommunications.Send, "ToSplunk")]
    public class SendToSplunk : PSCmdlet
    {
        [Parameter(Position = 1, Mandatory = true,
              ValueFromPipelineByPropertyName = true,
            HelpMessage = "The host name of the Splunk Instance")]
        [ValidateNotNullOrEmpty]
        public string SplunkHost { get; set; }

        [Parameter(Position = 2, Mandatory = true,
              ValueFromPipelineByPropertyName = true,
            HelpMessage = "The post of the Splunk Instance")]
        [ValidateNotNullOrEmpty]
        public int Port { get; set; }

        [Parameter(ValueFromPipeline = true, 
            ParameterSetName = "FromPipeline", 
            Mandatory = true)]
        [ValidateNotNullOrEmpty]
        public object InputObject { get; set; }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();
            Log.Information("{0}", InputObject);
        }

        protected override void BeginProcessing()
        {
            base.BeginProcessing();

            WriteVerbose("Setting up Serilog with Splunk");

            Log.Logger = new LoggerConfiguration()
                .WriteTo.SplunkViaTcp(SplunkHost, Port)
                .CreateLogger();
        }

        protected override void EndProcessing()
        {
            base.EndProcessing();
           // Log.Logger = null;
        }

        protected override void StopProcessing()
        {
            base.StopProcessing();
           // Log.Logger = null;
        }
    }
}