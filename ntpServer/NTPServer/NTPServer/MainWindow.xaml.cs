using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace NTPServer
{
    /// <summary>
    /// MainWindow.xaml 的交互逻辑
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private  string RunScript(string scriptText)
        {
            // create Powershell runspace
            Runspace runspace = RunspaceFactory.CreateRunspace();
            // open it
            runspace.Open();
            // create a pipeline and feed it the script text
            Pipeline pipeline = runspace.CreatePipeline();
            pipeline.Commands.AddScript(scriptText);
            pipeline.Commands.Add("Out-String");

            // execute the script
            Collection<PSObject> results = pipeline.Invoke();
            // close the runspace
            runspace.Close();

            // convert the script result into a single string
            StringBuilder stringBuilder = new StringBuilder();
            foreach (PSObject obj in results)
            {
                stringBuilder.AppendLine(obj.ToString());
            }

            
            return stringBuilder.ToString();
        }

        private void ButtonBase_OnClick(object sender, RoutedEventArgs e)
        {
            txtResult.Text= RunPowershell(@".\test.ps1", "");
           // txtResult.Text = RunScript("w32tm /resync");
        }


        //dosCommand Dos命令语句    
        public string Execute(string dosCommand)
        {
       
            return Execute(dosCommand, 10);
        }
        /// <summary>    
        /// 执行DOS命令，返回DOS命令的输出    
        /// </summary>    
        /// <param name="dosCommand">dos命令</param>    
        /// <param name="milliseconds">等待命令执行的时间（单位：毫秒），    
        /// 如果设定为0，则无限等待</param>    
        /// <returns>返回DOS命令的输出</returns>    
        public static string Execute(string command, int seconds)
        {

            string output = ""; //输出字符串    
            if (command != null && !command.Equals(""))
            {
                Process process = new Process();//创建进程对象    
                ProcessStartInfo startInfo = new ProcessStartInfo();
                startInfo.FileName = "cmd.exe";//设定需要执行的命令    
                startInfo.Arguments = "/C " + command;//“/C”表示执行完命令后马上退出    
                startInfo.UseShellExecute = false;//不使用系统外壳程序启动    
                startInfo.RedirectStandardInput = false;//不重定向输入    
                startInfo.RedirectStandardOutput = true; //重定向输出    
                startInfo.CreateNoWindow = true;//不创建窗口    
                startInfo.Verb = "RunAs";
                process.StartInfo = startInfo;
               
                try
                {
                    if (process.Start())//开始进程    
                    {
                        if (seconds == 0)
                        {
                            process.WaitForExit();//这里无限等待进程结束    
                        }
                        else
                        {
                            process.WaitForExit(seconds); //等待进程结束，等待时间为指定的毫秒    
                        }
                        output = process.StandardOutput.ReadToEnd();//读取进程的输出    
                    }
                }
                catch
                {
                }
                finally
                {
                    process?.Close();
                }
            }
            return output;
        }

       

        private void BtnRunPS_OnClick(object sender, RoutedEventArgs e)
        {
            try
            {
                using (Process process = new Process())
                {
                    FileInfo file = new FileInfo(@".\updateTime.ps1");
                    if (file.Directory != null)
                    {
                        process.StartInfo.WorkingDirectory = file.Directory.FullName;
                    }
                    process.StartInfo.FileName = @".\updateTime.ps1";
                    process.StartInfo.RedirectStandardOutput = true;
                    process.StartInfo.RedirectStandardError = true;
                    process.StartInfo.UseShellExecute = false;
                    process.StartInfo.CreateNoWindow = true;
                    process.Start();
                    process.WaitForExit(10000);
                    txtResult.Text = process.StandardOutput.ReadToEnd();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception Occurred :{0},{1}", ex.Message, ex.StackTrace.ToString());
            }
        }


        private string RunPowershell(string filePath, string parameters)
        {
            RunspaceConfiguration runspaceConfiguration = RunspaceConfiguration.Create();
            Runspace runspace = RunspaceFactory.CreateRunspace(runspaceConfiguration);
            runspace.Open();
            RunspaceInvoke scriptInvoker = new RunspaceInvoke(runspace);
            Pipeline pipeline = runspace.CreatePipeline();
            Command scriptCommand = new Command(filePath);
            Collection<CommandParameter> commandParameters = new Collection<CommandParameter>();
            foreach (var parameter in parameters.Split(' '))
            {
                CommandParameter commandParm = new CommandParameter(null, parameter);
                commandParameters.Add(commandParm);
                scriptCommand.Parameters.Add(commandParm);
            }
            pipeline.Commands.Add(scriptCommand);
            Collection<PSObject> psObjects;
            psObjects = pipeline.Invoke();
            return psObjects.ToString();
        }
    }
}
