<?php
require_once('time.php');

//Database variables
$RALI_GLOBAL = array();
$RALI_GLOBAL['host']		= "192.168.1.40"; 
$RALI_GLOBAL['user'] 		= "rali"; 
$RALI_GLOBAL['pass'] 		= "passw0rd"; 
$RALI_GLOBAL['db_name']   	= "rali_marketing"; 


//Application variables
$RALI_GLOBAL['debug_flag'] 	= true;
$RALI_GLOBAL['print_sql'] 	= false;
$RALI_GLOBAL['trace_flag'] 	= false;

//Processing Queue Variables
$RALI_GLOBAL['workers']                     = 4;
$RALI_GLOBAL['batch_limit']                 = 10000;
$RALI_GLOBAL['batch_insert_limit']          = 1000;
$RALI_GLOBAL['queue_log_resolution']        = 5;
$RALI_GLOBAL['check_queue_resolution']      = 1;

//Processing Calendar Variables
$RALI_GLOBAL['calendar_log_resolution']     = 10;
$RALI_GLOBAL['check_calendar_resolution']   = 5;



/*
This function prints a line with timestamp, script source and process id
*/
function msg($source,$pid,$str) {
	$ts=date('m-d-Y H:i:s');
	echo "$ts: $pid: $source: $str\n";
}

/*
This function prints a traceline with timestamp, script source and process id
*/
function trace($source,$pid,$str) {
	global $RALI_GLOBAL;
	
	if ($RALI_GLOBAL['trace_flag'])
	{
		echo_ts($source,$pid,"trace: $str");
		foreach($RALI_GLOBAL as $key->$value){
			echo "			$key					=	$value\n";
		}
	}
}

/*
This function prints a debug with timestamp, script source and process id
*/
function debug($source,$pid,$str) {
	global $RALI_GLOBAL;
	if ($RALI_GLOBAL['debug_flag'])
		msg($source,$pid,"debug: $str"); 
}

?>