<?php

require_once('application.php');
require_once('database.php');
global $DB;
global $RALI_GLOBAL;   //Thanks to http://www.daniweb.com/web-development/php/code/434480/using-phpmysqli-with-error-checking for the tip
//Insert a new batch

function insert_new_batch() {
    //Create the batch query
    $new_batch = array(
        'name' => 'new',
        'description' => 'new',
        'record_count' => '0'
    );
    $batch_id = insert_update_record("batch", $new_batch, true);
    $new_batch['id'] = $batch_id;
    return $new_batch;
}

//Obtain the queue records to process
function get_queue_records($batch, $lim) {
    $query = "
			SELECT 	id 
			FROM 	queue
			WHERE 	batch_id = $batch
                            AND queue_status_id = 1
			LIMIT $lim
			";
    $rs = execute_query($query);
    return $rs;
}

//Obtain the data to process with a specific process id
function get_processes($p) {
    $query = "
			SELECT 	id, batch_id, payload 
			FROM 	queue
			WHERE 	process_id = $p
			";
    $rs = execute_query($query);
    return $rs;
}

//Delete records from query with specific process id
function delete_queue_records($p) {
    $query = "
			DELETE 
			FROM 	queue
			WHERE 	process_id = $p
			";
    $rs = execute_query($query);
    return $rs;
}

//Insert a new batch
function update_batch_progress($id, $progress) {
    //Create the batch query
    global $DB;
    mysqli_autocommit($DB, FALSE);
    $query1 = "SELECT processed FROM batch WHERE id=$id FOR UPDATE";
    $rs = execute_query($query1);
    while ($row = mysqli_fetch_assoc($rs)) {
        $processed = $row['processed'];
    }
    $query2 = "UPDATE batch SET processed = $processed + $progress WHERE id=$id";
    $rs = execute_query($query2);
    mysqli_commit($DB);
    mysqli_autocommit($DB, TRUE);
    return $rs;
}

//Insert a new batch
function get_available_batchs() {
    //Create the batch query
    $query = "
			SELECT DISTINCT (batch_id) as id 
			FROM 	queue
			WHERE 	queue_status_id = 1
                        
			";
    $rs = execute_query($query);
    $batchs = array();
    while ($row = mysqli_fetch_assoc($rs)) {
        if (!is_null($row['id']))
            array_push($batchs, $row['id']);
    }

    return $batchs;
}

function mark_records_to_process($batch_id, $pid) {
    global $DB, $RALI_GLOBAL;
    mysqli_autocommit($DB, FALSE);
    $jobs = get_queue_records($batch_id, $RALI_GLOBAL['batch_limit']);

    //Load data in array
    $data = array();
    $process_id = microtime(true) + $pid;
    while ($row = $jobs->fetch_assoc()) {
        $row['process_id'] = $process_id;
        $row['queue_status_id'] = 3;
        array_push($data, $row);
    }

    //Update records to processing
    insert_upd_records("queue", $data);
    mysqli_commit($DB);
    mysqli_autocommit($DB, TRUE);
    return ($process_id);
}

function clean_workers($process_pool) {
    for ($i = 0; $i < count($process_pool); $i++) {

        if (!isProcessRunning($process_pool[$i])) {
            echo "Process $process_pool[$i] not running\n";
            array_splice($process_pool, $i, 1);
        }
    }
}

function isProcessRunning($PID) {

    if ($PID == 0)
        return false;
    if ($PID == "")
        return false;

    exec("ps -p $PID 2>&1", $state);
    return(count($state) >= 2);
}

?>