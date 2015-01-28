<?php
require_once('database.php');
global $DB;
global $db_debug;   //Thanks to http://www.daniweb.com/web-development/php/code/434480/using-phpmysqli-with-error-checking for the tip

//This function updates the calendar to the status passed in
function update_calendar($id,$st,$b_id){
	$data = array(
		'id' => $id,
		'calendar_status_id' => $st,
		'batch_id' => $b_id
	);
	$res = insert_update_record ("calendar",$data);
	return $res;
	
}

//We get the records needed for the queue
function get_cal_info(){
	$query = "
		SELECT 	calendar.id, payload
		FROM 	calendar
		WHERE 	calendar.date_to_process < NOW() 
			AND calendar.calendar_status_id = 1
			;

		";
	$rs=execute_query($query);
	return $rs;
}

//We get the records needed for the queue
function get_cal_records($j_id){
	$query = "
		SELECT 	batch_id, payload
		FROM 	calendar
		WHERE 	calendar.id = $j_id
		";
	$rs=execute_query($query);
	return $rs;
}

//This function query the batch table and returns one record to update
function get_complete_record(){
	$query = "
		SELECT 	max(batch.id) as batch_id, calendar.id as job_id
		FROM 	batch, calendar
		WHERE 	batch.record_count = batch.processed
			AND	calendar.batch_id = batch.id
			AND calendar.calendar_status_id = 3
		";
	$rs=execute_query($query);
	return $rs;
}

?>