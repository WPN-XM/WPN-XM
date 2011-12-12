/*
    WPN-XM Server Control Panel

    WPN-XM SCP is a tool to manage Nginx, PHP and MariaDb daemons under windows.
    It's a fork of Easy WEMP originally written by Yann Le Moigne and (c) 2010.
    WPN-XM SCP is written by Jens-Andre Koch and (c) 2011 - onwards.
        
    This file is part of WPN-XM Serverpack for Windows.

    WPN-XM SCP is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    WPN-XM SCP is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with WPN-XM SCP. If not, see <http://www.gnu.org/licenses/>.
*/

// QT includes
#include <QApplication>
#include <QMenu>
#include <QAction>
#include <QPushButton>
#include <QWidgetAction>
#include <QMessageBox>
#include <QSettings>
#include <QDir>
#include <QTimer>
#include <QDesktopServices>
#include <QUrl>
#include <QPlastiqueStyle>
#include <QDebug>

// WPN-XM SCP includes
#include "wpnxm-tray.h"
#include "hostmanager/hostmanagerdialog.h"

// Constructor
WpnxmTray::WpnxmTray(QApplication *parent) : QSystemTrayIcon(parent)
{
    // Tray Icon
    setIcon(QIcon(":/wpnxm"));

    initializeConfiguration();

    createTrayMenu();

    timer = new QTimer(this);
    timer->setInterval(1000); // msec
    connect(timer, SIGNAL(timeout()), this, SLOT(updateGlobalStatusImage()));


    processNginx = new QProcess(this);
    processNginx->setWorkingDirectory(cfgNginxDir);
    connect(processNginx, SIGNAL(stateChanged(QProcess::ProcessState)), this, SLOT(nginxStateChanged(QProcess::ProcessState)));
    connect(processNginx, SIGNAL(error(QProcess::ProcessError)), this, SLOT(nginxProcessError(QProcess::ProcessError)));

    processPhp = new QProcess(this);
    processPhp->setWorkingDirectory(cfgPhpDir);
    connect(processPhp, SIGNAL(stateChanged(QProcess::ProcessState)), this, SLOT(phpStateChanged(QProcess::ProcessState)));
    connect(processPhp, SIGNAL(error(QProcess::ProcessError)), this, SLOT(phpProcessError(QProcess::ProcessError)));

    processMySql = new QProcess(this);
    processMySql->setWorkingDirectory(cfgMySqlDir);
    connect(processMySql, SIGNAL(stateChanged(QProcess::ProcessState)), this, SLOT(mysqlStateChanged(QProcess::ProcessState)));
    connect(processMySql, SIGNAL(error(QProcess::ProcessError)), this, SLOT(mysqlProcessError(QProcess::ProcessError)));

    if(bAutostartDaemons)
    {
        runAll();
    }
}

// Destructor
WpnxmTray::~WpnxmTray()
{
    stopAll();
    processNginx->waitForFinished();
    processPhp->waitForFinished();
    processMySql->waitForFinished();
    delete MainMenu;
}

void WpnxmTray::initializeConfiguration()
{
    // if the cfg file doesn't already exist, it is created
    QSettings globalSettings("wpnxm.ini", QSettings::IniFormat, this);

    // check if reading settings was successful
    if(globalSettings.status() != QSettings::NoError)
    {
        QMessageBox::critical(0, tr("Settings"), tr("Can't read settings."));
        exit(1);
    }

    /*
     * Declation of Default Settings for WPN-XM Server Control Panel
     */
    bAutostartDaemons       = globalSettings.value("global/autostartdaemons", true).toBool();

    cfgPhpDir               = globalSettings.value("path/php", "./bin/php").toString();
    cfgPhpExec              = globalSettings.value("php/exec", "/php-cgi.exe").toString();
    cfgPhpFastCgiHost       = globalSettings.value("php/fastcgi-bindaddress", "localhost").toString();
    cfgPhpFastCgiPort       = globalSettings.value("php/fastcgi-bindport", "9000").toString();

    cfgNginxDir             = globalSettings.value("path/nginx", "./bin/nginx").toString();
    cfgNginxExec            = globalSettings.value("nginx/exec", "/nginx.exe").toString();
    cfgNginxSites           = globalSettings.value("nginx/sites", "/html").toString();
    cfgNginxConfig          = globalSettings.value("nginx/config", "/conf").toString();
    cfgNginxLogs            = globalSettings.value("nginx/logs", "/logs").toString();

    cfgMySqlDir             = globalSettings.value("path/mysql", "./bin/mysql").toString();
    cfgMySqlExec            = globalSettings.value("mysql/exec", "/bin/mysqld.exe").toString();
    cfgMySqlConfig          = globalSettings.value("mysql/config", "/my.ini").toString();
    cfgMySqlClientExec      = globalSettings.value("mysql/clientExec", "/bin/mysql.exe").toString();

    cfgMySqlWorkbenchDir    = globalSettings.value("path/mysqlworkbench", "./bin/mysqlworkbench").toString();
    cfgMySqlWorkbenchExec   = globalSettings.value("mysqlworkbench/exec", "/MySQLWorkbench.exe").toString();
}

void WpnxmTray::createTrayMenu()
{
    MainMenu = new QMenu();
    //MainMenu->setStyle(new QPlastiqueStyle);

    // Global status
    globalStatusSubmenu = new QMenu("Global status", MainMenu);
    globalStatusSubmenu->setIcon(QIcon(":/status_stop"));
    globalStatusSubmenu->addAction(QIcon(":/action_restart"), tr("Restart All"), this, SLOT(restartAll()), QKeySequence());
    globalStatusSubmenu->addSeparator();
    globalStatusSubmenu->addAction(QIcon(":/action_run"), tr("Start All"), this, SLOT(runAll()), QKeySequence());
    globalStatusSubmenu->addAction(QIcon(":/action_stop"), tr("Stop All"), this, SLOT(stopAll()), QKeySequence());

    // Nginx
    nginxStatusSubmenu = new QMenu("NGINX status", MainMenu);
    nginxStatusSubmenu->setIcon(QIcon(":/status_stop"));
    nginxStatusSubmenu->addAction(QIcon(":/action_reload"), tr("Reload"), this, SLOT(reloadNginx()), QKeySequence());
    nginxStatusSubmenu->addSeparator();
    nginxStatusSubmenu->addAction(QIcon(":/action_restart"), tr("Restart"), this, SLOT(restartNginx()), QKeySequence());
    nginxStatusSubmenu->addSeparator();
    nginxStatusSubmenu->addAction(QIcon(":/action_run"), tr("Start"), this, SLOT(runNginx()), QKeySequence());
    nginxStatusSubmenu->addAction(QIcon(":/action_stop"), tr("Stop"), this, SLOT(stopNginx()), QKeySequence());

    QMenu* nginxConfigSubmenu = new QMenu("NGINX config", MainMenu);
    nginxConfigSubmenu->setIcon(QIcon(":/nginx"));
    nginxConfigSubmenu->addAction(tr("Open site folder"), this, SLOT(openNginxSite()), QKeySequence());
    nginxConfigSubmenu->addSeparator();
    nginxConfigSubmenu->addAction(tr("Open configuration folder"), this, SLOT(openNginxConfig()), QKeySequence());
    nginxConfigSubmenu->addAction(tr("Open log folder"), this, SLOT(openNginxLogs()), QKeySequence());

    // PHP
    phpStatusSubmenu = new QMenu("PHP status", MainMenu);
    phpStatusSubmenu->setIcon(QIcon(":/status_stop"));
    phpStatusSubmenu->addAction(QIcon(":/action_restart"), tr("Restart"), this, SLOT(restartPhp()), QKeySequence());
    phpStatusSubmenu->addSeparator();
    phpStatusSubmenu->addAction(QIcon(":/action_run"), tr("Start"), this, SLOT(runPhp()), QKeySequence());
    phpStatusSubmenu->addAction(QIcon(":/action_stop"), tr("Stop"), this, SLOT(stopPhp()), QKeySequence());

    QMenu* phpConfigSubmenu = new QMenu("PHP Config", MainMenu);
    phpConfigSubmenu->setIcon(QIcon(":/php"));
    phpConfigSubmenu->addAction("Open php config", this, SLOT(openPhpConfig()), QKeySequence());

    // MySQL
    mysqlStatusSubmenu = new QMenu("MySql status", MainMenu);
    mysqlStatusSubmenu->setIcon(QIcon(":/status_stop"));
    mysqlStatusSubmenu->addAction(QIcon(":/action_restart"), tr("Restart"), this, SLOT(restartMySQL()), QKeySequence());
    mysqlStatusSubmenu->addSeparator();
    mysqlStatusSubmenu->addAction(QIcon(":/action_run"), tr("Start"), this, SLOT(runMySQL()), QKeySequence());
    mysqlStatusSubmenu->addAction(QIcon(":/action_stop"), tr("Stop"), this, SLOT(stopMySQL()), QKeySequence());

    QMenu* mysqlConfigSubmenu = new QMenu("MySql Config", MainMenu);
    mysqlConfigSubmenu->setIcon(QIcon(":/mysql"));
    mysqlConfigSubmenu->addAction(QIcon(":/mysqlworkbench"), tr("Open MySQL workbench"), this, SLOT(openMySqlWorkbench()), QKeySequence());
    mysqlConfigSubmenu->addAction(QIcon(":/cmd"), tr("Open MySQL client"), this, SLOT(openMySqlClient()), QKeySequence());
    mysqlConfigSubmenu->addSeparator();
    mysqlConfigSubmenu->addAction(tr("Open mysql config"), this, SLOT(openMySqlConfig()), QKeySequence());

    //QUrl url(SUPPORT_URL);
    //QDesktopServices::openUrl(url);
    // QDesktopServices::openUrl(QUrl("file:///C:/Documents and Settings/All Users/Desktop", QUrl::TolerantMode));

    // Build main menu
    MainMenu->addMenu(globalStatusSubmenu);
    MainMenu->addSeparator();
    MainMenu->addMenu(nginxStatusSubmenu);
    MainMenu->addMenu(phpStatusSubmenu);
    MainMenu->addMenu(mysqlStatusSubmenu);
    MainMenu->addSeparator();
    MainMenu->addAction(tr("Manage Hosts"), this, SLOT(manageHosts()), QKeySequence());
    MainMenu->addMenu(nginxConfigSubmenu);
    MainMenu->addMenu(phpConfigSubmenu);
    MainMenu->addMenu(mysqlConfigSubmenu);
    MainMenu->addSeparator();
    MainMenu->addAction(tr("&Help"), this, SLOT(goToWebsiteHelp()), QKeySequence());
    MainMenu->addAction(tr("&Quit"), parent(), SLOT(quit()), QKeySequence());
    setContextMenu(MainMenu);
}

void WpnxmTray::goToWebsiteHelp()
{
    QDesktopServices::openUrl(QUrl("http://www.clansuite.com/"));
}

//*
//* Action slots
//*
void WpnxmTray::runAll()
{
    runNginx();
    runPhp();
    runMySQL();
}

void WpnxmTray::stopAll()
{
    stopMySQL();
    stopPhp();
    stopNginx();
}

void WpnxmTray::restartAll()
{
    restartNginx();
    restartPhp();
    restartMySQL();
}

/*
 * Nginx - Actions: run, stop, restart
 */
void WpnxmTray::runNginx()
{
    if(processNginx->state() != QProcess::NotRunning)
    {
        QMessageBox::warning(0, tr("Nginx"), tr("Nginx already running."));
        return;
    }
    processNginx->start(cfgNginxDir+cfgNginxExec);
}

void WpnxmTray::stopNginx()
{
    QProcess processStopNginx;
    processStopNginx.setWorkingDirectory(cfgNginxDir);
    processStopNginx.start(cfgNginxDir+cfgNginxExec, QStringList() << "-s" << "stop");
    processStopNginx.waitForFinished();
}

void WpnxmTray::reloadNginx()
{
    QProcess processStopNginx;
    processStopNginx.setWorkingDirectory(cfgNginxDir);
    processStopNginx.start(cfgNginxDir+cfgNginxExec, QStringList() << "-s" << "reload");
    processStopNginx.waitForFinished();
}

void WpnxmTray::restartNginx()
{
    stopNginx();
    runNginx();
}

/*
 * PHP - Actions: run, stop, restart
 */
void WpnxmTray::runPhp()
{
    if(processPhp->state() != QProcess::NotRunning)
    {
        QMessageBox::warning(0, tr("PHP"), tr("PHP is already running."));
        return;
    }
    processPhp->start(cfgPhpDir+cfgPhpExec, QStringList() << "-b" << cfgPhpFastCgiHost+":"+cfgPhpFastCgiPort);
}

void WpnxmTray::stopPhp()
{
    processPhp->kill();
    processPhp->waitForFinished();
}

void WpnxmTray::restartPhp()
{
    stopPhp();
    runPhp();
}

/*
 * MySql Actions - run, stop, restart
 */
void WpnxmTray::runMySQL()
{
    if(processMySql->state() != QProcess::NotRunning){
        QMessageBox::warning(0, tr("MySQL"), tr("MySQL already running."));
        return;
    }
    QDir dir(QDir::currentPath());
    QString strDir = QDir::toNativeSeparators(dir.absoluteFilePath(cfgMySqlDir));
    processMySql->start(cfgMySqlDir+cfgMySqlExec, QStringList() << "--basedir="+strDir);
}

void WpnxmTray::stopMySQL()
{    
    processMySql->kill();
    processMySql->waitForFinished();
}

void WpnxmTray::restartMySQL()
{
    stopMySQL();
    runMySQL();
}

/*
 * Config slots
 */
void WpnxmTray::manageHosts()
{
    HostManagerDialog dlg;
    dlg.exec();
}

void WpnxmTray::openNginxSite()
{
    QDir dir(QDir::currentPath());
    QString strDir = QDir::toNativeSeparators(dir.absoluteFilePath(cfgNginxDir+cfgNginxSites));

    // start as own process ( not as a child process), will live after Tray terminates
    QProcess::startDetached("explorer", QStringList() << strDir);
}

void WpnxmTray::openNginxConfig(){
    QDir dir(QDir::currentPath());
    QString strDir = QDir::toNativeSeparators(dir.absoluteFilePath(cfgNginxDir+cfgNginxConfig));
    QProcess::startDetached("explorer", QStringList() << strDir);
}

void WpnxmTray::openNginxLogs()
{
    QDir dir(QDir::currentPath());
    QString strDir = QDir::toNativeSeparators(dir.absoluteFilePath(cfgNginxDir+cfgNginxLogs));
    QProcess::startDetached("explorer", QStringList() << strDir);
}

void WpnxmTray::openMySqlClient()
{
    QProcess::startDetached(cfgMySqlDir+cfgMySqlClientExec, QStringList(), cfgMySqlDir);
}

void WpnxmTray::openMySqlWorkbench()
{
    QProcess::startDetached(cfgMySqlWorkbenchDir+cfgMySqlWorkbenchExec, QStringList(), cfgMySqlWorkbenchDir);
}

void WpnxmTray::openMySqlConfig()
{
    QDir dir(QDir::currentPath());
    QString strDir = QDir::toNativeSeparators(dir.absoluteFilePath(cfgMySqlDir+"/my.ini"));
    QProcess::startDetached("cmd", QStringList() << "/c" << "start "+strDir);
}

void WpnxmTray::openPhpConfig()
{
    QDir dir(QDir::currentPath());
    QString strDir = QDir::toNativeSeparators(dir.absoluteFilePath(cfgPhpDir+"/php.ini"));
    QProcess::startDetached("cmd", QStringList() << "/c" << "start "+strDir);
}

/*
 * State slots
 */
void WpnxmTray::globalStateChanged()
{
    QProcess::ProcessState stateNginx = QProcess::Running;
    QProcess::ProcessState statePhp = QProcess::Running;
    QProcess::ProcessState stateMySql = QProcess::Running;

    stateNginx = processNginx->state();
    statePhp = processPhp->state();
    stateMySql = processMySql->state();

    if(stateNginx==QProcess::Starting || statePhp==QProcess::Starting || stateMySql==QProcess::Starting)
    {
        timer->start();
    }
    else
    {
        timer->stop();
        setIcon(QIcon(":/wpnxm"));
    }

    if(stateNginx==QProcess::NotRunning && statePhp==QProcess::NotRunning && stateMySql==QProcess::NotRunning)
    {
        globalStatusSubmenu->setIcon(QIcon(":/status_stop"));
        return;
    }

    if(stateNginx==QProcess::Running && statePhp==QProcess::Running && stateMySql==QProcess::Running)
    {
        globalStatusSubmenu->setIcon(QIcon(":/status_run"));
        return;
    }

    globalStatusSubmenu->setIcon(QIcon(":/status_runstop"));
    return;
}

void WpnxmTray::nginxStateChanged(QProcess::ProcessState state)
{
    switch(state)
    {
        case QProcess::NotRunning:
            nginxStatusSubmenu->setIcon(QIcon(":/status_stop"));
            break;
        case QProcess::Running:
            nginxStatusSubmenu->setIcon(QIcon(":/status_run"));
            break;
        case QProcess::Starting:
            nginxStatusSubmenu->setIcon(QIcon(":/status_reload"));
            break;
    }
    globalStateChanged();
}

void WpnxmTray::phpStateChanged(QProcess::ProcessState state)
{
    switch(state)
    {
        case QProcess::NotRunning:
            phpStatusSubmenu->setIcon(QIcon(":/status_stop"));
            break;
        case QProcess::Running:
            phpStatusSubmenu->setIcon(QIcon(":/status_run"));
            break;
        case QProcess::Starting:
            phpStatusSubmenu->setIcon(QIcon(":/status_reload"));
            break;
    }
    globalStateChanged();
}

void WpnxmTray::mysqlStateChanged(QProcess::ProcessState state)
{
    switch(state)
    {
        case QProcess::NotRunning:
            mysqlStatusSubmenu->setIcon(QIcon(":/status_stop"));
            break;
        case QProcess::Running:
            mysqlStatusSubmenu->setIcon(QIcon(":/status_run"));
            break;
        case QProcess::Starting:
            mysqlStatusSubmenu->setIcon(QIcon(":/status_reload"));
            break;
    }
    globalStateChanged();
}

void WpnxmTray::updateGlobalStatusImage()
{
    if(iCurrentImage < 1 || iCurrentImage > 4)
    {
        iCurrentImage = 0;
    }    
    setIcon(QIcon(":/load"+iCurrentImage));
}

/*
 * Error slots
 */
void WpnxmTray::nginxProcessError(QProcess::ProcessError error)
{
    QMessageBox::warning(0, "Error - WPX-XM Server Control Panel", "Nginx error : "+getProcessErrorMessage(error));
}

void WpnxmTray::phpProcessError(QProcess::ProcessError error)
{
    QMessageBox::warning(0, "Error - WPX-XM Server Control Panel", "PHP error : "+getProcessErrorMessage(error));
}

void WpnxmTray::mysqlProcessError(QProcess::ProcessError error)
{
    QMessageBox::warning(0, "Error - WPX-XM Server Control Panel", "MySQL error : "+getProcessErrorMessage(error));
}

QString WpnxmTray::getProcessErrorMessage(QProcess::ProcessError error){
    QString ret;
    switch(error){
        case QProcess::FailedToStart:
            ret = "The process failed to start. Either the invoked program is missing, or you may have insufficient permissions to invoke the program.";
            break;
        case QProcess::Crashed:
            ret = "The process crashed some time after starting successfully.";
            break;
        case QProcess::Timedout:
            ret = "The process timed out.";
            break;
        case QProcess::WriteError:
            ret = "An error occurred when attempting to write to the process. For example, the process may not be running, or it may have closed its input channel.";
            break;
        case QProcess::ReadError:
            ret = "An error occurred when attempting to read from the process. For example, the process may not be running.";
            break;
        case QProcess::UnknownError:
            ret = "An unknown error occurred.";
            break;
    }
    return ret;
}
