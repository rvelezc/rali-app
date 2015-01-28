#!/usr/bin/php
<?php
require_once('include/database.php');
require_once('include/queue.php');
require_once('include/calendar.php');
require_once('include/time.php');

global $DB;
global $db_debug;   //Thanks to http://www.daniweb.com/web-development/php/code/434480/using-phpmysqli-with-error-checking for the tip
global $ENCO_GLOBAL;

//Globals
$script="check_queue";
$pid=getmypid();
$loop = 0;

while (true){
	//Get number of records in queue
	
	//$batch_id = get_max_from_table("queue", "batch_id", "queue_status_id = 1");
	$batches = get_available_batchs();
	$batch_idx = 0;
	$process_pool = array();
	while (! empty($batches)) {
		// while ($batch_id > 0) {
		//First Mark first batch to process
		$batch_id = $batches[$batch_idx];
		echo_ts($script,$pid,"Loading data into queue");
		$process_id = mark_records_to_process($batch_id, $pid);
		echo_ts($script,$pid,"Starting process:$process_id, batch:$batch_id");
		//exec("./process.php $process_id >> /rali/rali-app/local/log/rali.log 2>&1");		
		$child_pid =  exec("./process.php $process_id >> /rali/rali-app/local/log/rali.log 2>&1 & echo $!");
		array_push($process_pool,$child_pid);
		echo "new PID: $child_pid   Process Pool Count  ".count($process_pool)."\n";
		while (count($process_pool) >= $RALI_GLOBAL['workers'])
		{
			clean_workers ($process_pool);
			sleep(1);
		}
			
		$batches = get_available_batchs();
		if (count($batches) > 0)
		$batch_idx = ($batch_idx + 1) % count($batches);
			//$batch_id = get_max_from_table("queue", "batch_id", "queue_status_id = 1");
	}
	if ($loop == 0) echo_ts($script,$pid,"No jobs on queue");
	$loop = ($loop + 1)%$RALI_GLOBAL['queue_log_resolution']/$RALI_GLOBAL['check_queue_resolution'] ;
	sleep($RALI_GLOBAL['check_queue_resolution'] );
}


?>
