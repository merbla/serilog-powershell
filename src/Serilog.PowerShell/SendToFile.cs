using System.Management.Automation;

namespace Serilog.PowerShell
{
    [Cmdlet(VerbsCommunications.Send, "ToFile")]
    public class SendToFile : PSCmdlet
    {
        [Parameter(Position = 1, Mandatory = true,
            ValueFromPipelineByPropertyName = true,
            HelpMessage = "The path of the file to write to")]
        [ValidateNotNullOrEmpty]
        public string FilePath
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
                .WriteTo.File(FilePath)
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

          //TODO: Dispose??
            Log.Logger = null;
        }


    }
}