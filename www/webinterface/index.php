<?php
include __DIR__ . DIRECTORY_SEPARATOR . 'serverpack.core.php';
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>WPИ-XM Serverstack for Windows</title>
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
    <meta name="description" content="WPИ-XM Serverpack for Windows - Webinterface.">
    <link rel="shortcut icon" href="http://wpn-xm.org/favicon.ico" />
    <link rel="stylesheet" href="css/style.css" type="text/css" media="screen, projection" />
</head>
<body>

    <!-- container-for-centering -->
    <div class="page-centered">

        <!-- Main -->
        <div class="center">

            <!-- Headline -->
            <h1 class="headline">
                WPИ-XM<br/>
                Serverstack for Windows<br/>
                <small>Version 0.2</small>
            </h1>

            <div class="content-centered">

            <!-- Server Software (left box) -->
            <div class="server-software-left-box">

                <h2>Server Software</h2>

                <div class="cs-message">

                    <h3>Main Components</h3>

                        <table class="cs-message-content">
                        <tr>
                            <td class="td-with-image">
                                Webserver
                            </td>
                            <td>
                                <div class="resourceheader">
                                    <img class="res-header-icon" src="http://cdn.clansuite.com/images/report.png" alt="Report Icon" />
                                        <a href="http://nginx.org/">
                                            <b>NGINX <?php echo Wpnxm_Serverpack::getNGINXVersion(); ?></b>
                                        </a>
                                        <br /><br />
                                        <small>NGINX [engine x] is a high performance http and reverse proxy server, as well as a mail proxy server written by Igor Sysoev.</small>
                                        <p>
                                        License: <a href="http://nginx.org/LICENSE">2-clause BSD-like license</a>
                                        </p>
                                </div>
                            </td>
                        </tr>
                        </table>

                        <table class="cs-message-content">
                        <tr>
                            <td class="td-with-image">
                                Scripting Language
                            </td>
                            <td>
                                <div class="resourceheader">
                                    <img class="res-header-icon" src="http://cdn.clansuite.com/images/report.png" alt="Report Icon" />
                                        <a href="http://php.net/">
                                            <b>PHP <?php echo Wpnxm_Serverpack::getPHPVersion(); ?></b>
                                        </a>
                                        <br /><br />
                                        <small>PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML.</small>
                                        <p>
                                        License: <a href="http://php.net/license/index.php">PHP License</a>
                                        </p>
                                 </div>
                            </td>
                        </tr>
                        </table>

                        <table class="cs-message-content">
                        <tr>
                            <td class="td-with-image">
                               Database
                            </td>
                            <td>
                                <div class="resourceheader">
                                    <img class="res-header-icon" src="http://cdn.clansuite.com/images/report.png" alt="Report Icon" />
                                        <a href="http://mariadb.org/">
                                            <b>MariaDB <?php echo Wpnxm_Serverpack::getMariaDBVersion(); ?></b>
                                        </a>
                                        <br /><br />
                                        <small>MariaDB is a fork of the world's most popular open source database MySQL by the original author. MariaDb is a binary drop-in replacement for MySQL.</small>
                                        <p>
                                        License: <a href="http://kb.askmonty.org/en/mariadb-license/">GNU/GPL v2</a>
                                        </p>
                                 </div>
                            </td>
                        </tr>
                        </table>

                        <table class="cs-message-content">
                        <tr>
                            <td class="td-with-image">
                               Memcached
                            </td>
                            <td>
                                <div class="resourceheader">
                                    <img class="res-header-icon" src="http://cdn.clansuite.com/images/report.png" alt="Report Icon" />
                                        <a href="http://memcached.org/">
                                            <b>Memcached <?php echo Wpnxm_Serverpack::getMemcachedVersion(); ?></b>
                                        </a>
                                        <br /><br />
                                        <small>memcached is a high-performance, distributed memory object caching system. originally intended for speeding up applications by alleviating database load.</small>
                                        <p>
                                        License: <a href="https://github.com/memcached/memcached/blob/master/LICENSE/">New BSD License</a>
                                        </p>
                                 </div>
                            </td>
                        </tr>
                        </table>

                         <table class="cs-message-content">
                        <tr>
                            <td class="td-with-image">
                               Xdebug
                            </td>
                            <td>
                                <div class="resourceheader">
                                    <img class="res-header-icon" src="http://cdn.clansuite.com/images/report.png" alt="Report Icon" />
                                        <a href="http://xdebug.org/">
                                            <b>Xdebug <?php echo Wpnxm_Serverpack::getXdebugVersion(); ?></b>
                                        </a>
                                        <br /><br />
                                        <small>The Xdebug extension for PHP helps you debugging your scripts by providing a lot of valuable debug information.</small>
                                        <p>
                                        License: <a href="http://xdebug.org/license.php">Xdebug License</a>
                                        </p>
                                 </div>
                            </td>
                        </tr>
                        </table>


                 </div><!-- END: cs-message -->
            </div><!-- END: Server Software (left box) -->

            <!-- Server Environment (right box) -->
            <div class="server-environment-right-box">

                <h2>Server Environment</h2>

                <div class="cs-message">

                    <h3>Overview</h3>

                   <table class="cs-message-content">
                   <tr>
                        <td colspan="2">
                            <div class="resourceheader2 bold">
                                Nginx
                            </div>
                        </td>
                   </tr>
                   <tr>
                     <td class="width-25">Host : Port</td>
                     <td class="right"><?php echo $_SERVER['SERVER_NAME'] ?>:<?php echo $_SERVER['SERVER_PORT'] ?> </td>
                   </tr>
                   <tr>
                     <td>Directory</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::getBaseDir() . '\bin\nginx'; ?></td>
                   </tr>
                   <tr>
                     <td>Config</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::getBaseDir() . '\bin\nginx\conf\nginx.conf'; ?></td>
                   </tr>
                   <tr>
                     <td colspan="2" class="right">
                        <span class="aButton">Configure</span>
                        <span class="aButton">Access Log</span>
                        <span class="aButton">Error Log</span>
                     </td>
                   </tr>
                   </table>

                   <table class="cs-message-content">
                   <tr>
                        <td colspan="2">
                            <div class="resourceheader2 bold">
                                PHP
                            </div>
                        </td>
                   </tr>
                   <tr>
                     <td class="width-42 left">Host : Port</td>
                     <td class="right"><?php echo $_SERVER['SERVER_NAME'] ?>:<?php echo $_SERVER['SERVER_PORT'] ?></td>
                   </tr>
                   <tr>
                     <td>Directory</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::getBaseDir() . '\bin\php'; ?></td>
                   </tr>
                   <tr>
                     <td>Config</td>
                     <td class="right"><?php echo get_cfg_var('cfg_file_path'); ?></td>
                   </tr>
                   <tr>
                     <td colspan="2" class="right">
                        <span class="aButton">Configure</span>
                        <span class="aButton">Show Log</span>
                        <a class="aButton" href="phpinfo.php">Show phpinfo()</a>
                     </td>
                   </tr>
                   </table>

                   <table class="cs-message-content">
                   <tr>
                        <td colspan="2">
                            <div class="resourceheader2 bold">
                                MariaDB
                            </div>
                        </td>
                   </tr>
                   <tr>
                     <td class="width-42 left">Host : Port</td>
                     <td class="right">localhost:port</td>
                   </tr>
                   <tr>
                     <td>Username | Password</td>
                     <td class="right"><span class="red">root</span> | <span class="red">toop</span></td>
                   </tr>
                   <tr>
                     <td>Directory</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::getBaseDir() . '\bin\mariadb';?></td>
                   </tr>
                   <tr>
                     <td>Config</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::getBaseDir() .  '\mariadb\my.ini';?></td>
                   </tr>
                   <tr>
                     <td colspan="2" class="right"><span class="aButton">Configure</span><span class="aButton">Show Log</span><span class="aButton">Reset Password</span>
                     </td>
                   </tr>
                   </table>

                   <table class="cs-message-content">
                   <tr>
                        <td colspan="2">
                            <div class="resourceheader2 bold">
                                Memcached
                            </div>
                        </td>
                   </tr>
                   <tr>
                     <td class="width-42 left">Host : Port</td>
                     <td class="right">localhost:port</td>
                   </tr>
                   <tr>
                     <td>PHP Extension</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::assertExtensionInstalled('memcached');?></td>
                   </tr>
                   <tr>
                     <td colspan="2" class="right"><span class="aButton">Switch on/off</span>
                     </td>
                   </tr>
                   </table>

                   <table class="cs-message-content">
                   <tr>
                        <td colspan="2">
                            <div class="resourceheader2 bold">
                                XDebug
                            </div>
                        </td>
                   </tr>
                   <tr>
                     <td class="width-42 left">Host : Port</td>
                     <td class="right">localhost:port</td>
                   </tr>
                   <tr>
                     <td>Installed & Configured</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::assertExtensionInstalled('xdebug');?></td>
                   </tr>
                   <tr>
                     <td>Extension Type</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::getXdebugExtensionType();?></td>
                   </tr>
                   <tr>
                     <td colspan="2" class="right"><span class="aButton">Switch on/off</span>
                     </td>
                   </tr>
                   </table>

                </div><!-- END: cs-message -->
           </div><!-- END: Server Environment (rught box) -->

    </div><!-- End: Content -->

</div><!-- End: Main -->

<br class="clear" />

<div id="footer">
    <hr class="footer-line" />
    <p>&copy; 2010-<?php echo date("Y"); ?> by Jens-Andr&#x00E9; Koch Softwaresystemtechnik.
        <br />
    </p>
</div>

</div>
</body>
</html>