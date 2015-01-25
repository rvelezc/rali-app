#!/usr/bin/php
<?php
require_once('include/application.php');
require_once('include/database.php');
require_once('include/queue.php');
require_once('include/calendar.php');
require_once('include/time.php');

global $DB;
global $ENCO_GLOBAL;   //Thanks to http://www.daniweb.com/web-development/php/code/434480/using-phpmysqli-with-error-checking for the tip
$script="load_to_queue";
$pid=getmypid();

$job_id = $argv[1];
$batch_id = $argv[2];
echo_ts($script,$pid,"Loading job $job_id from batch $batch_id to queue table");
		
$data = array();
$status = 3;

//Get the records
echo_ts($script,$pid,"Getting records from calendar, list and contact tables");
$jobs = get_cal_records($job_id); 

//Update Batch table to include number of records
echo_ts($script,$pid,"Updating batch $batch_id with $jobs->num_rows records");
$batch = array(
	'id' => $batch_id,
	'record_count' => $jobs->num_rows
);
insert_update_record("batch",$batch);

//Insert everything on the queue, by batches
echo_ts($script,$pid,"Loading data into queue");
$i = 0;
while ($row = $jobs->fetch_assoc()) {
    array_push($data, $row);
    $i = ($i + 1) % $ENCO_GLOBAL['batch_insert_limit'];
    if ($i == 0){
        insert_multiple_records ("queue",$data);
        $data = array();
    }
}
//Insert the remaining items
insert_multiple_records ("queue",$data);

//Update Calendar to Processing Status
echo_ts($script,$pid,"Updating calendar to Processing");
update_calendar($job_id,$status,$batch_id);

?>
