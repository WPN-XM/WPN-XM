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

class Projects
{
    private $dirs = array();

    /**
     * The array defines paths of the www folder.
     * These are not "Your Projects", but infrastructure and tools for WPN-XM.
     * This is used for exclusion of folders when fetching project directories.
     */
    private $toolDirectories = array(
        'adminer' => 'adminer/adminer.php',
        'phpmyadmin' => '',
        'webgrind' => '',
        'webinterface' => '',
        'xhprof' => 'xhprof/xhprof_html'
    );

    function __construct()
    {
        $this->dirs = $this->fetchProjectDirectories();
    }

    private function fetchProjectDirectories()
    {
        $dirs = array();

        $handle=opendir(WPNXM_WWW_DIR); # __DIR__

        while ($dir = readdir($handle))
        {
            if ($dir == "." or $dir == "..")
            {
                continue;
            }

            // exclude WPN-XM infrastructure and tool directories
            if (array_key_exists($dir, $this->toolDirectories))
            {
                continue;
            }

            if (is_dir(WPNXM_WWW_DIR . $dir) === true)
            {
                $dirs[] = $dir;
            }
        }

        closedir($handle);

        asort($dirs);

        return $dirs;
    }

    public function listProjects()
    {
        if ($this->getNumberOfProjects() == 0)
        {
            echo "No project dirs found.";
        }
        else
        {
            foreach($this->dirs as $dir)
            {
            	if(!$this->vhost_exists($dir))
            		echo '<li><a class="folder" href="' . WPNXM_ROOT . $dir . '">' . $dir . '</a> <a href="' . WPNXM_ROOT . 'webinterface/addvhost.php?newvhost=' . $dir .'">[+vhost]</a></li>';
            	else
            		echo '<li><a class="folder" href="http://' . $dir . '/">' . $dir . '</a></li>';
            }
        }
    }

    public function listTools()
    {
        foreach($this->toolDirectories as $dir => $href)
        {
            if($href =='')
            {
                echo '<li><a class="folder" href="' . WPNXM_ROOT . $dir . '">' . $dir . '</a></li>';
            }
            else
            {
                echo '<li><a class="folder" href="' . WPNXM_ROOT . $href . '">' . $dir . '</a></li>';
            }
        }
    }

    // check if a seperate vhost is added in \bin\nginx\conf\vhosts\
    public function vhost_exists( $dir ){
    	return file_exists( WPNXM_DIR . '/bin/nginx/conf/vhosts/' . $dir . '.conf' );    		
    }
     
    /**
     * tools directories are hardcoded.
     * because we don't know which ones the user installed,
     * we check for existence.
     * if a tool dir is not there, remove it from the list
     * this affects the counter
     */
    public function checkWhichToolDirectoriesAreInstalled()
    {
        foreach($this->toolDirectories as $dir => $href)
        {
            if(is_dir(WPNXM_WWW_DIR . $dir) === false)
            {
                unset($this->toolDirectories[$dir]);
            }
        }
    }

    public function getNumberOfProjects()
    {
        return count($this->dirs);
    }

    public function getNumberOfTools()
    {
        $this->checkWhichToolDirectoriesAreInstalled();

        return count($this->toolDirectories);
    }
}
?>