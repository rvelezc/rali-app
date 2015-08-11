#!/usr/bin/php
<?php
require_once('include/database.php');
require_once('include/queue.php');
require_once('include/calendar.php');
require_once('include/time.php');
require_once('../email/email.php');
require_once('../social/facebook.php');


global $DB;
//global $RALI_GLOBAL;   //Thanks to http://www.daniweb.com/web-development/php/code/434480/using-phpmysqli-with-error-checking for the tip

//Globals
$script="process";
$pid=getmypid();
$process_id = $argv[1];
$data_process = array();
$data_transaction = array();

//Get records and do a first pass to update process status
$processes = get_processes($process_id);
debug($script,$pid,"Procesing $process_id, $processes->num_rows records found");
while ($row = $processes->fetch_assoc()) {
	//Add queue status as completed
	$batch_id = $row['batch_id'];
	$row['queue_status_id'] = 4;
	array_push($data_process, $row);
}

//Process records 
foreach($data_process as $row) {
	$res = array();
	$payload = unserialize(base64_decode($row['payload']));
	//debug($script,$pid,"Rafa: " . $row['payload']);
	//debug($script,$pid,"Rafa: " . $payload);

	msg($script,$pid,"Sending ". $payload['type']." msg\n");
	$res = process_payload($payload,$script,$pid);    
	$row['error'] = $res['error'];
	$row['response'] = $res['response'];
	debug($script,$pid,"Msg Processed with error:".$res['error'].", msg: ".$res['response']);
	
	//Push data to insert data after processed and invalidate id column
	unset($row['id']);
	unset($row['queue_status_id']);
	array_push($data_transaction, $row);
}

//Update records to completed
insert_upd_records("queue",$data_process);
debug($script,$pid,"Queue table updated");

//Insert records in transaction table
insert_upd_records("transaction",$data_transaction);
debug($script,$pid,"Creating records in transaction");

//Update batch records
update_batch_progress($batch_id,$processes->num_rows);
debug($script,$pid,"Updating batch progress with $processes->num_rows records");

//Delete records from queue
delete_queue_records($process_id);
debug($script,$pid,"Queue cleaned");
 
//This function sends an email
function process_payload($payload,$script,$pid){
	$result = array (
		'error' => '1',
		'response' => "Type not found"
	);
	
	if ( $payload['type'] == "email" ) {
		debug($script,$pid,"Sending email");
		$result = send_email($payload);
	}else if ( $payload['type'] == "facebook" ) {
		debug($script,$pid,"Sending facebook");
		$result = send_message($payload);
	}
	return $result;
}

?>
