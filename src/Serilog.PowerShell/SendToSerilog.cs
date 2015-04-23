using System.Collections.Generic;
using System.Management.Automation;

namespace Serilog.PowerShell
{
    [Cmdlet(VerbsCommunications.Send, "ToSerilog")]
    public class SendToSerilog : PSCmdlet
    {
        [Parameter(Position = 1, Mandatory = true,
            ValueFromPipelineByPropertyName = true,
            HelpMessage = "The path of the file to write to")]
        [ValidateNotNullOrEmpty]
        public Dictionary<string,string> Settings
        {
            get;
            set;
        }

        [Parameter(ValueFromPipeline = true,
            ParameterSetName = "FromPipeline",
            Mandatory = true)]
        [ValidateNotNullOrEmpty]
        public object InputObject { get; set; }

        protected override void BeginProcessing()
        {
            base.BeginProcessing();

            Log.Logger = new LoggerConfiguration()
                .ReadFrom.KeyValuePairs(Settings)
                .CreateLogger();
        }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            Log.Information("{0}", InputObject);
        }

        protected override void EndProcessing()
        {
            base.EndProcessing();
             
        }


    }
}