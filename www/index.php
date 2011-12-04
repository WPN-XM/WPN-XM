<?php
define('WPNXM_WWW_DIR', __DIR__ . DIRECTORY_SEPARATOR . 'webinterface' . DIRECTORY_SEPARATOR);
include WPNXM_WWW_DIR . 'serverpack.core.php';
include WPNXM_WWW_DIR . 'projects.core.php';
include WPNXM_WWW_DIR . 'menu.core.php';
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
    <link rel="stylesheet" href="webinterface/css/style.css" type="text/css" media="screen, projection" />
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

            <!-- Top Menu Navigation -->
            <?php Menu::render(); ?>

	<!-- Welcome Message -->
	<div id="content" style="font-family: 'Lucida Grande',Verdana,Arial,Sans-Serif;">
	    <h1>Welcome to the WPИ-XM server stack!</h1>
	</div>

	<div class="right-box">

		<?php $projects = new Projects(); ?>

		<div class="cs-message">

			<!-- Widget: Projects (scanned project paths / www folder) -->
			<div class="cs-message-content">
				<h2>Projects (<?php echo $projects->getNumberOfProjects(); ?>)</h2>
				<?php $projects->listProjects(); ?>
			</div>

			<!-- Widget: Tools (selected set of paths / www folder) -->
			<div class="cs-message-content">
				<h2>Tools (<?php echo $projects->getNumberOfTools(); ?>)</h2>
				<?php $projects->listTools(); ?>
			</div>
		</div>

	</div>

<br class="clear" />

<div id="footer">
    <hr class="footer-line"/>
    <p>&copy; 2010-<?php echo date("Y"); ?> by Jens-Andr&#x00E9; Koch Softwaresystemtechnik.
        <br />
    </p>
</div>

</div><!-- END centering-->
</body>
</html>