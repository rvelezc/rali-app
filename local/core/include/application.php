<?php
require_once('time.php');

//Database variables
$ENCO_GLOBAL = array();
$ENCO_GLOBAL['host']		= "192.168.1.110"; 
$ENCO_GLOBAL['user'] 		= "encontexto"; 
$ENCO_GLOBAL['pass'] 		= "passw0rd"; 
$ENCO_GLOBAL['db_name']   	= "encontexto"; 


//Application variables
$ENCO_GLOBAL['debug_flag'] 	= true;
$ENCO_GLOBAL['print_sql'] 	= false;
$ENCO_GLOBAL['trace_flag'] 	= false;

//Processing Queue Variables
$ENCO_GLOBAL['workers']                     = 4;
$ENCO_GLOBAL['batch_limit']                 = 10000;
$ENCO_GLOBAL['batch_insert_limit']          = 1000;
$ENCO_GLOBAL['queue_log_resolution']        = 5;
$ENCO_GLOBAL['check_queue_resolution']      = 1;

//Processing Calendar Variables
$ENCO_GLOBAL['calendar_log_resolution']     = 10;
$ENCO_GLOBAL['check_calendar_resolution']   = 5;



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
	global $ENCO_GLOBAL;
	
	if ($ENCO_GLOBAL['trace_flag'])
	{
		echo_ts($source,$pid,"trace: $str");
		foreach($ENCO_GLOBAL as $key->$value){
			echo "			$key					=	$value\n";
		}
	}
}

/*
This function prints a debug with timestamp, script source and process id
*/
function debug($source,$pid,$str) {
	global $ENCO_GLOBAL;
	if ($ENCO_GLOBAL['debug_flag'])
		msg($source,$pid,"debug: $str"); 
}

?>