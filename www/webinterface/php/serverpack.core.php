<?php
   /**
    * WPИ-XM Serverpack
    * Jens-André Koch © 2010 - onwards
    * http://wpn-xm.org/
    *
    *        _\|/_
    *        (o o)
    +-----oOO-{_}-OOo------------------------------------------------------------------+
    |                                                                                  |
    |    LICENSE                                                                       |
    |                                                                                  |
    |    WPИ-XM Serverpack is free software; you can redistribute it and/or modify     |
    |    it under the terms of the GNU General Public License as published by          |
    |    the Free Software Foundation; either version 2 of the License, or             |
    |    (at your option) any later version.                                           |
    |                                                                                  |
    |    WPИ-XM Serverpack is distributed in the hope that it will be useful,          |
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
    * @license    GNU/GPL v2 or (at your option) any later version, see "license.txt".
    * @author     Jens-André Koch <jakoch@web.de>
    * @copyright  Jens-André Koch (2010 - 2011)
    * @link       http://wpn-xm.org/
    * @version    SVN: $Id: serverpack.core.php 5795 2011-11-09 12:39:38Z vain $
    */

class Wpnxm_Serverpack
{
    /**
     * Defines the following Path Constants
     * 
     * WPNXM_DIR     -> wpn-xm/ Root Folder (bin, configs, ....)
     * WPNXM_WWW_DIR -> wpn-xm/www
     * WPNXM_PHP_DIR -> wpn-xm/www/webinterface
     */
    public static function defineDirectories()
    {
        if(!defined('WPNXM_DIR'))
        {
            define('WPNXM_DIR', dirname(dirname(dirname(__DIR__))) . DIRECTORY_SEPARATOR);
            define('WPNXM_WWW_DIR', WPNXM_DIR . 'www' . DIRECTORY_SEPARATOR); 
            define('WPNXM_PHP_DIR', WPNXM_WWW_DIR . 'webinterface/php' . DIRECTORY_SEPARATOR);
        }        
    }
    
    /**
     * Returns the base directory / installation folder of the WPИ-XM Serverpack.
     *
     * @return string Base directory of the WPИ-XM Serverpack.
     */
    public static function getBaseDir()
    {        
        return WPNXM_WWW_DIR;        
    }

    public static function get_MySQL_datadir()
    {
        $myini_array = file("../mysql/my.ini");
        $key_datadir =  key(preg_grep("/^datadir/", $myini_array));
        $mysql_datadir_array = explode("\"",$myini_array[$key_datadir]);
        $mysql_datadir = str_replace("/","\\", $mysql_datadir_array[1]);

        return $mysql_datadir;
    }

    /**
     * Returns MariaDB Version.
     *
     * @return string MariaDB Version
     */
    public static function getMariaDBVersion()
    {
        if(false === function_exists('mysql_get_server_info'))
        {
            return; # extension mysql, mysqli, mysqlnd missing
        }

        # mysql_get_server_info() returns e.g. "5.3.0-maria"
        $arr = explode('-', mysql_get_server_info());
        return $arr[0];
    }

    /**
     * Returns PHP Version.
     *
     * @return string PHP Version
     */
    public static function getPHPVersion()
    {
        return PHP_VERSION;
    }

    /**
     * Returns Nginx Version.
     *
     * @return string Nginx Version
     */
    public static function getNGINXVersion()
    {
        return substr($_SERVER["SERVER_SOFTWARE"], 6);
    }

    /**
     * Returns Xdebug Version.
     *
     * @return string Xdebug Version
     */
    public static function getXdebugVersion()
    {
        $xdebug_version = false;

        $phpinfo = self::fetchPHPInfo();

        // Check phpinfo content for Xdebug as Zend Extension
        if ( preg_match( '/with\sXdebug\sv([0-9.rcdevalphabeta-]+),/', $phpinfo, $matches ) )
        {
            $xdebug_version = $matches[1];
        }

        return $xdebug_version;
    }

    /**
     * Tests, if the extension file is found.
     *
     * @param string $extension Extension name, e.g. xdebug, memcached.
     * @return bool True if $extension file is found, false otherwise.
     */
    public static function assertExtensionFileFound($extension)
    {
        $file_exists = false;

        switch ($extension) {
            case "xdebug":
                if(is_file(self::getBaseDir() . '\bin\php\ext\php_xdebug.dll') === true)
                {
                    $file_exists = true;
                }
                break;
            case "memcached":
                if(is_file(self::getBaseDir() . '\bin\php\ext\php_memcache.dll') === true)
                {
                    $file_exists = true;
                }
                break;
        }

        return $file_exists;
    }

    /**
     * Tests, if an extension is correctly configured and loaded.
     *
     * @param string $extension Extension to check.
     * @return bool True if loaded, false otherwise.
     */
    public static function assertExtensionConfigured($extension)
    {
        $loaded = false;

        switch ($extension) {
            case "xdebug":
                $phpinfo = self::fetchPHPInfo();

                // Check phpinfo content for Xdebug as Zend Extension
                if ( preg_match( '/with\sXdebug\sv([0-9.rcdevalphabeta-]+),/', $phpinfo, $matches ) )
                {
                    $loaded = true;
                }

                // Check phpinfo content for Xdebug as normal PHP extension
                if ( preg_match( '/xdebug support/', $phpinfo, $matches ) )
                {
                    $loaded = true;
                }

                unset($phpinfo);

                break;
            case "memcached":
                if(is_file(self::getBaseDir() . '\bin\php\ext\php_memcache.dll') === true)
                {
                    $loaded = true;
                }
                break;
        }

        return $loaded;
    }

    public static function getXdebugExtensionType()
    {
        $phpinfo = self::fetchPHPInfo();

        // Check phpinfo content for Xdebug as Zend Extension
        if ( preg_match( '/with\sXdebug\sv([0-9.rcdevalphabeta-]+),/', $phpinfo, $matches ) )
        {
            return 'Zend Extension';
        }

        // Check phpinfo content for Xdebug as normal PHP extension
        if ( preg_match( '/xdebug support/', $phpinfo, $matches ) )
        {
            return 'PHP Extension';
        }

        return ':(';
    }

    /**
     * Tests, if an extension is installed,
     * by ensuring that the extension file exists and is correctly configured.
     *
     * @param string $extension Extension to check.
     * @return bool True if installed, false otherwise.
     */
    public static function assertExtensionInstalled($extension)
    {
         $installed = false;

         if(self::assertExtensionFileFound($extension) === true and self::assertExtensionConfigured($extension) === true)
         {
             $installed = true;
         }

         return $installed;
    }

    /**
     * Returns memcached Version.
     *
     * @return string memcached Version
     */
    public static function getMemcachedVersion()
    {
        if (extension_loaded('memcache') === false)
        {
            return ':(off)'; # the extension is missing
        }

        $matches = new Memcached();
        $matches->addServer('localhost', 11211);
        return $matches->getVersion();
    }

    /**
     * Returns the (full) content of phpinfo().
     *
     * @return string Content of phpinfo()
     */
    public static function getPHPInfoContent()
    {
        # fetch the output of phpinfo into a buffer and assign it to a variable
        ob_start();
        phpinfo();
        $buffered_phpinfo = ob_get_contents();
        ob_end_clean();

        return $buffered_phpinfo;
    }

    /**
     * Returns only the body content of phpinfo().
     *
     * @return string phpinfo
     */
    public static function fetchPHPInfo()
    {
        $buffered_phpinfo = self::getPHPInfoContent();
        # only the body content
        preg_match_all("=<body[^>]*>(.*)</body>=siU", $buffered_phpinfo, $result);
        $phpinfo = $result[1][0];
        $phpinfo = str_replace(";", "; ", $phpinfo);

        return $phpinfo;
    }

    public static function determinePort($daemon)
    {

    }

    /**
     * Attempts to establish a connection to the specified port (on localhost)
     */
    public static function portCheck($daemon)
    {

    }
}
?>