<?php
   /**
    * WPИ-XM Server Stack - Webinterface
    * Jens-André Koch © 2010 - onwards
    * http://wpn-xm.org/
    *
    *        _\|/_
    *        (o o)
    +-----oOO-{_}-OOo------------------------------------------------------------------+
    |                                                                                  |
    |    LICENSE                                                                       |
    |                                                                                  |
    |    WPИ-XM Serverstack is free software; you can redistribute it and/or modify    |
    |    it under the terms of the GNU General Public License as published by          |
    |    the Free Software Foundation; either version 2 of the License, or             |
    |    (at your option) any later version.                                           |
    |                                                                                  |
    |    WPИ-XM Serverstack is distributed in the hope that it will be useful,         |
    |    but WITHOUT ANY WARRANTY; without even the implied warranty of                |
    |    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                 |
    |    GNU General Public License for more details.                                  |
    |                                                                                  |
    |    You should have received a copy of the GNU General Public License             |
    |    along with this program; if not, write to the Free Software                   |
    |    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA    |
    |                                                                                  |
    +----------------------------------------------------------------------------------+
    *
    * @license    GNU/GPL v2 or (at your option) any later version..
    * @author     Jens-André Koch <jakoch@web.de>
    * @copyright  Jens-André Koch (2010 - 2012)
    * @link       http://wpn-xm.org/
    */

/**
 * Include the common startup with paths / constants, etc.
 */
include dirname(__DIR__) . '/php/bootstrap.php';
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>WPИ-XM Serverstack for Windows</title>
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
    <meta name="description" content="WPИ-XM Serverstack for Windows - Webinterface.">
    <link rel="shortcut icon" href="http://wpn-xm.org/favicon.ico" />
    <link rel="stylesheet" href="css/style.css" type="text/css" media="screen, projection" />
</head>
<body>

<div class="page-wrapper">

    <div class="center">

        <h1 class="headline">
            WPИ-XM<br/>
            Serverstack for Windows<br/>
            <small>Version <?php echo WPNXM_VERSION; ?></small>
        </h1>

        <?php
        	if(!defined('WPNXM_NON_MENUE_HEADER')){
	            include WPNXM_TEMPLATE . 'htmlelements.php';
	
	            HtmlElements::renderMenu();
	            HtmlElements::renderWelcome();
        	}
        ?>

        <div class="content-centered">
