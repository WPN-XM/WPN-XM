<?php


/**
 * @author Tobias Fichtner <github@tobiasfichtner.com>
 * @category vhost managment
 * @package vhm
 * @subpackage add
 * @version 0.1
 */


// template for new vhosts
define( 'VHOST_TMPL' , '
# automaticly generated vhost
# beware - manual editing will not be considered if there are regenerating by wpn-xm!

server {
        listen       127.0.0.1:80;
        server_name  %%vhost%%;

        log_not_found off;

        access_log  logs/%%vhost%%.log  main;

        location / {
            root   www/%%vhost%%;
            index  index.php index.html index.htm;
        }

        location ~ \.php$ {
            root           www/%%vhost%%;
            fastcgi_pass   127.0.0.1:9100;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include        fastcgi_params;
        }
}
');

include __DIR__ . '/php/bootstrap.php';

$new_vhost = NULL ;
if(isset($_GET['newvhost']) && !empty($_GET)){
	$new_vhost = $_GET['newvhost'];
	$confdir = '/bin/nginx/conf/';
	$filedir =  WPNXM_DIR . $confdir . 'vhosts/';
	$filename = $filedir . $new_vhost . '.conf';
	
	// add vhosts configuration file in \bin\nginx\conf\vhosts
	clearstatcache();
	if(!is_writable($filename) && is_writable($filedir)){
		$hostfile = file_put_contents($filename, str_replace('%%vhost%%', $new_vhost, VHOST_TMPL));
	}
	else{
		die( 'vhost-configuration file already exists.' );
	}
	
	// add include-line for new vhost file in \bin\nginx\conf\vhosts.conf
	clearstatcache();
	if(is_writable( WPNXM_DIR . $confdir . 'vhosts.conf') ){
		$hostfile = file_put_contents( WPNXM_DIR . $confdir . 'vhosts.conf', "\n #automaticly added vhost configuration file \n include vhosts/$new_vhost.conf;" , FILE_APPEND );
	}
	else{
		die( 'vhosts.conf file is not write-able or doesnt exists.' );
	}

	//reload nginx configuration, add hosts entry and flush ipcache
	$WshShell = new COM("WScript.Shell");
	$cmd_restartNginx = 'cmd /c "'.  WPNXM_DIR . '\bin\nginx\nginx.exe -p ' . WPNXM_DIR . ' -c ' . WPNXM_DIR . '\bin\nginx\conf\nginx.conf -s reload"';
	$cmd_addHosts = 'cmd /c "' . WPNXM_DIR . '\bin\tools\hosts' . ' add ' . $_SERVER['SERVER_ADDR'] . ' ' . $new_vhost . ' # atomaticaly added from wpn-xm host managment"' ;
	$cmd_ipflush = 'ipconfig /flushdns';
	
	// run commands to add host to nginx
	$oExec = $WshShell->run($cmd_restartNginx , 0, false);
	passthru($cmd_addHosts);
	$oExec = $WshShell->run($cmd_ipflush , 0, false);
	
	// wait a second for dns flush
	sleep(1);
	
	// forward to new host
	header("Location: http://$new_vhost/");
}
?>