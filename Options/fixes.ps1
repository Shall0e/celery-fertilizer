$localAppData = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::localApplicationData)
$ErrorActionPreference= 'silentlycontinue'
$ProgressPreference = 'silentlycontinue'

Add-Type -TypeDefinition @'
using System;
using System.Diagnostics;
using System.IO;

public class ProcessHelper
{
    public static void StartProcessWithOutputRedirect(string executablePath, string arguments, string outputPath)
    {
        Process process = new Process();
        process.StartInfo.FileName = executablePath;
        process.StartInfo.Arguments = arguments;
        process.StartInfo.RedirectStandardOutput = true;
        process.StartInfo.UseShellExecute = false;

        try
        {
            using (StreamWriter outputFile = new StreamWriter(outputPath, append: false)) // Ensure overwrite
            {
                process.StartInfo.CreateNoWindow = false; // Optionally hide the window
                process.OutputDataReceived += (sender, e) =>
                {
                    if (!String.IsNullOrEmpty(e.Data))
                    {
                        outputFile.WriteLine(e.Data);
                        Console.WriteLine(e.Data); // Optionally print output to console
                    }
                };

                process.Start();
                process.BeginOutputReadLine();
                process.WaitForExit();
            }
            Console.WriteLine("Process completed and output redirected to " + outputPath);
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
        }
    }
}
'@

if (Test-Path $outputPath) {
    Clear-Content $outputPath
}

[ProcessHelper]::StartProcessWithOutputRedirect((Join-Path $localAppData "Celery\CeleryInject.exe"), "-RedirectStandardOutput", ".\TerminalOutput.txt")
