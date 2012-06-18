<?php

/**
* re-direction script for download sources
* @author Tobias Fichtner <github@tobiasfichtner.com>
*/

$pool = Array(
	'nginx' => 'http://www.nginx.org/download/nginx-1.2.1.zip',
	'php' => 'http://windows.php.net/downloads/releases/php-5.4.4-nts-Win32-VC9-x86.zip',
	'mariadb' => 'http://mirror3.layerjet.com/mariadb/mariadb-5.5.24/windows/mariadb-5.5.24-win32.zip',
	'phpext_xdebug' => 'http://xdebug.org/files/php_xdebug-2.2.0RC2-5.4-vc9-nts.dll',
	'phpext_memcached' => 'http://downloads.php.net/pierre/php_memcache-2.2.6-5.3-vc9-x86.zip',
	'phpext_zeromq' => 'http://snapshot.zero.mq/download/win32/php53-ext/php-zmq-20111011_12-39.zip',
	'phpext_apc' => 'http://wpn-xm.org/files/php_apc-3.1.10-5.4-vc9-x86-xp.zip',
	'phpmyadmin' => 'http://netcologne.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/3.4.9/phpMyAdmin-3.4.9-english.zip',
	'adminer' => 'http://downloads.sourceforge.net/adminer/adminer-3.3.4.php',
	'memcached' => 'http://downloads.northscale.com/memcached-1.4.5-x86.zip',
	'junction' => 'http://download.sysinternals.com/files/Junction.zip',
	'pear' => 'http://pear.php.net/go-pear.phar',
	'wpnxmscp' => 'http://wpn-xm.org/files/wpn-xm-scp-0.3.0.zip',
	'webgrind' => 'http://webgrind.googlecode.com/files/webgrind-release-1.0.zip',
	'xhprof' => 'http://nodeload.github.com/preinheimer/xhprof/zipball/master',
	'clansuite' => 'http://nodeload.github.com/jakoch/Clansuite/zipball/svnsync'
);

if(isset($_GET['s']) && !empty($_GET['s']) && array_key_exists( $_GET['s'] , $pool)){
	header("Location: " . $pool[$_GET['s']] );
}
else{
	// header for fcgi
	header("Status: 404 Not Found");
	// header for non-fcgi
	@header("HTTP/1.0 404 Not Found");
}

?>