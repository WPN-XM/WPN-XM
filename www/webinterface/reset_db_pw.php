<?php

/**
 * @author Tobias Fichtner <github@tobiasfichtner.com>
 */


define('WPNXM_NON_MENUE_HEADER', TRUE);

include __DIR__ . '/php/bootstrap.php';
include WPNXM_TEMPLATE . 'header.php';

$s = filter_input(INPUT_GET, 'check', FILTER_SANITIZE_STRING);
$newPW = filter_input(INPUT_POST, 'newPW', FILTER_SANITIZE_STRING);
if($s == "change" && !empty($newPW)){
	// commands
	$stop_mariadb = "taskkill /f /IM mysqld.exe 1>nul 2>nul";
	$start_mariadb_change_pw = WPNXM_DIR . "bin\\tools\\runhiddenconsole.exe " . WPNXM_DIR . "bin\\mariadb\\bin\\mysqld.exe --defaults-file=". WPNXM_DIR . 'bin\\mariadb\\my.ini --init-file=' . WPNXM_DIR . 'bin\\mariadb\\init_passwd_change.txt';
	$start_mariadb_normal = WPNXM_DIR . "bin\\tools\\runhiddenconsole.exe " . WPNXM_DIR . "bin\\mariadb\\bin\\mysqld.exe --defaults-file=". WPNXM_DIR . 'bin\\mariadb\\my.ini';
	
	$stdOut = "reset password<br/>";
	// kill mysqld
	
	// create the init-file with passwd update query
	file_put_contents( WPNXM_DIR . 'bin\\mariadb\\init_passwd_change.txt' , "UPDATE mysql.user SET Password=PASSWORD('$newPW') WHERE User='root';");
	
	// start mysqld again with init-file to change passwd
	passthru($stop_mariadb);
	passthru($start_mariadb_change_pw);
	sleep("5");
	passthru($stop_mariadb);
	passthru($start_mariadb_normal);
	
	#sleep("10");
	
	$db_check = new mysqli("localhost" , "root" , $newPW , "mysql" );
	if($db_check->connect_errno){
		$stdOut .= "FAILED: test connection<br/>(MySQL [" . $db_check->connect_errno . "]" . $db_check->connect_error . ")";
	}
	else{
		$stdOut .= "<p>SUCCESS: test connection successful</p>";
		unlink(WPNXM_DIR . 'bin\\mariadb\\init_passwd_change.txt');
	}
	
	$stdOut .= '<input type="button" onclick="window.close();" value="close" />';
}
else{
	$stdOut = '
	<form style="width:400px;" action="' . WPNXM_WEBINTERFACE_ROOT . basename( __FILE__ ) . '?check=change" method="POST" >
	<fieldset><legend>set new ROOT password for mariadb-server</legend>
		<br/><input type="text" name="newPW"><br/><br/>
		<input type="button" onclick="window.close();" value="cancel" />
		<div style="width:100px;float:right;"></div>
		<input type="submit" name="change" value="change password" />
	</fieldset>
	</form>
	';
}

echo $stdOut;

include WPNXM_TEMPLATE . 'footer.php';
?>