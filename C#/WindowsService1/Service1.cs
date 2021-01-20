using System;
using System.Diagnostics;
using System.IO;
using System.ServiceProcess;
using System.Text;

namespace WindowsService1
{
    public partial class Service1 : ServiceBase
    {
        public Service1()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            //サービスが起動された時の処理を記載
            WriteLog(string.Format("Service is starting."));

            //Applicationログを見張る
            EventLog eLog = new EventLog("Application");
            //Applicationログが作成されたときに実行するファンクションを定義
            eLog.EntryWritten += new EntryWrittenEventHandler(EventLog_OnEntryWritten);
            eLog.EnableRaisingEvents = true;

            //フォルダを監視する
            FileSystemWatcher watcher = new FileSystemWatcher();
            //監視するフォルダを指定
            watcher.Path = @"C:\FileWatcher\";
            watcher.NotifyFilter = NotifyFilters.LastAccess | NotifyFilters.LastWrite
               | NotifyFilters.FileName | NotifyFilters.DirectoryName;
            //監視するファイルのフィルタ
            watcher.Filter = "*.*";
            //ファイルが作成された時に実行するファンクションを定義
            watcher.Created += new FileSystemEventHandler(ErrorFile_OnCreated);
            //ファイルがリネームされた時に実行するファンクションを定義
            watcher.Renamed += new RenamedEventHandler(ErrorFile_OnCreated);
            watcher.EnableRaisingEvents = true;
        }

        protected override void OnStop()
        {
            //サービスが停止された時の処理を記載
            WriteLog(string.Format("Service is stopping."));
        }

        // 指定したEventログが作成されるごとに呼ばれる関数
        public void EventLog_OnEntryWritten(object source, EntryWrittenEventArgs e)
        {
            WriteLog(string.Format("Event Created : {0}", e.Entry.Message));
            // Entry Type / Source / Instance Id等で後続処理のフィルタ
            if (!e.Entry.EntryType.ToString().Trim().ToUpper().Contains("information".ToUpper()))
            {
                return;
            }

            if (!e.Entry.Source.ToString().Trim().ToUpper().Contains("Security-SPP".ToUpper()))
            {
                return;
            }

            if (!e.Entry.InstanceId.ToString().Trim().ToUpper().Contains("16394".ToUpper()))
            {
                return;
            }
            //イベントログが作成されたときに実行したい処理
            WriteLog(string.Format("Event Created : {0}", e.Entry.Message));
        }

        public void ErrorFile_OnCreated(object source, FileSystemEventArgs e)
        {
            //ファイル作成時に行う処理
            //例えば、ログに記載、メール送信　など・・・
            WriteLog(string.Format("File Created : {0}", e.FullPath));
        }
        private void WriteLog(string logMessage)
        {
            string logFile = @"C:\FileWatcher\log.txt";
            string logDate = string.Format("{0:MM/dd/yy H:mm:ss}: ", DateTime.Now);
            StreamWriter w = new StreamWriter(logFile, true);
            using (w)
            {
                w.WriteLine(logDate + logMessage);
            }
        }
    }
}
