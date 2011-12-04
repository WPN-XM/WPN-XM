<?php
class Projects
{
    private $dirs = array();

    /**
     * The array defines paths of the www folder.
     * These are not "Your Projects", but infrastructure and tools for WPN-XM.
     * This is used for exclusion of folders when fetching project directories.
     */
    private $toolDirectories = array(
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

        $handle=opendir(__DIR__);

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

            if (is_dir($dir) === true)
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
                echo '<li><a class="folder" href="' . $dir . '">' . $dir . '</a></li>';
            }
        }
    }

    public function listTools()
    {
        foreach($this->toolDirectories as $dir => $href)
        {                       
            if($href =='')
            {
                echo '<li><a class="folder" href="' . $dir . '">' . $dir . '</a></li>';
            }
            else
            {
                echo '<li><a class="folder" href="' . $href . '">' . $dir . '</a></li>';
            }            
        }
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