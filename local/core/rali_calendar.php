#!/usr/bin/php
<?php
require_once('include/application.php');
require_once('include/database.php');
require_once('include/queue.php');
require_once('include/calendar.php');
require_once('include/time.php');

global $DB;
global $RALI_GLOBAL;   //Thanks to http://www.daniweb.com/web-development/php/code/434480/using-phpmysqli-with-error-checking for the tip

//Script variables, used for tracing and loging
$script="check_calendar";
$pid=getmypid();
$loop = 0;

msg($script,$pid,"Starting Calendar Check script");
trace($script,$pid,"Starting Calendar Check script");

while (true){
	//Get number of records in calendar past due
	$job_cnt = get_record_count("calendar","id","calendar.date_to_process < NOW() AND calendar.calendar_status_id = 1");
	if ($loop == 0) debug($script,$pid,"Number of calendar jobs past due $job_cnt");
	while ($job_cnt > 0) {
		
			//Create a new batch and get its id
			$batch = insert_new_batch();
			debug($script,$pid,"New Batch Created $batch");
			
			//Get the records
			$jobs = get_cal_info($batch['id']); 
			debug($script,$pid,"Calendar info obtained");
			$row = mysqli_fetch_assoc($jobs);
			
			
			//Update the batch info
			$batch['record_count'] = $jobs->num_rows;
			$batch['name'] = $row['client'] . "-" . $row['id'] ;
			$batch['description'] = $row['client'] . "-" . $row['campaign'] . "-" . $row['list'] . "-" . $row['content_type'];
			$job_id=$row['id'];
			$batch_id = $batch['id'];
			insert_update_record("batch",$batch);
			debug($script,$pid,"Batch $batch_id updated");
			
			//Update Calendar to Loading so next loop dont get it
			/* 	1	Created
				2	Loading
				3	OnProgress
				4	Completed 
			*/
			$status = 2;
			update_calendar($job_id,$status,$batch_id);
			debug($script,$pid,"Calendar entry for job $job_id updated with batch $batch_id");
			
			//call the script to load to queue in the background and move on
			msg($script,$pid,"Starting loading job:$job_id, batch:$batch_id");
			exec("./load_to_queue.php $job_id $batch_id >> /rali/rali-app/local/log/rali.log 2>&1 &");
			$job_cnt = get_record_count("calendar","id","calendar.date_to_process < NOW() AND calendar.calendar_status_id = 1");
			debug($script,$pid,"Number of calendar jobs past due $job_cnt");
	}
	if ($loop == 0)	msg($script,$pid,"No jobs on calendar to process");
	
	//Check if there are jobs completed in the queue, batch and transactions table, and update calendar job status
	$jobs_completed = get_record_count("batch,calendar","batch.id","batch.record_count = batch.processed AND calendar.batch_id = batch.id AND calendar.calendar_status_id = 3");
	if ($loop == 0)	debug($script,$pid,"$jobs_completed jobs on calendar completed");
	while ($jobs_completed > 0) {
		msg($script,$pid,"Updating jobs status to completed");
		$job_to_upd = get_complete_record();
		$row = mysqli_fetch_assoc($job_to_upd);
		$job_id=$row['job_id'];
		$batch_id = $row['batch_id'];
		$status = 4;
		update_calendar($job_id,$status,$batch_id);
		$jobs_completed = get_record_count("batch,calendar","batch.id","batch.record_count = batch.processed AND calendar.batch_id = batch.id AND calendar.calendar_status_id = 3");
	}
	
	$loop = ($loop + 1)%($RALI_GLOBAL['calendar_log_resolution']/$RALI_GLOBAL['check_calendar_resolution']);
	sleep($RALI_GLOBAL['check_calendar_resolution']);
}


?>
