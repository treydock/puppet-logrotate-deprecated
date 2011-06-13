/*

 Class: logrotate::params
Do NOT include this class - it won't do anything.
Set variables for names and paths

*/
class logrotate::params {
	
	case $operatingsystem {
    	CentOS: {
			$log_dir = '/var/log/'
    		$logrotate_archive_dir = "$log_dir/archives"
		}
	}
}
