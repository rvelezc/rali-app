<?php
require_once('time.php');
require_once('application.php');

//$host 		= "192.168.1.40"; 
$host 		= "localhost"; 
$user 		= "rali"; 
$pass 		= "passw0rd"; 
$db_name   	= "rali_marketing"; 
$limit      = 10;
$DB = mysqli_connect($host,$user,$pass,$db_name) or die("Error " . mysqli_error($DB));

/*
This function executes a query
*/
function execute_query($query) {
	global $DB, $ENCO_GLOBAL;
	$script="database"; $pid=getmypid();
	$result = $DB->query($query);
	if ($ENCO_GLOBAL['print_sql'] ) { echo_ts($script,$pid,"Query:\n\n$query\n\n"); }
	if (!$result and $ENCO_GLOBAL['debug_flag']) {
		// the query failed and debugging is enabled
		echo_ts ($script,$pid,"There was an error in query:\n\n $query \n");
		echo_ts ($script,$pid, $DB->error);
		
	}
	return $result;
}


/*
This function gets the count of records from the table passed in
*/
function get_record_count($table,$id,$where = '') {
	global $DB;
	$query = "SELECT count($id) as cnt \nFROM $table\n"; 
	if (strlen($where) > 0) {
		$query = $query . " WHERE $where\n";
	}
	$rs=execute_query($query);
	while ($row = mysqli_fetch_assoc($rs)) {
		$cnt = $row['cnt'];
	}
	return $cnt;
}

function get_max_from_table($table, $field, $where) {
	$query = "SELECT max($field) as max FROM $table";
	if (strlen($where) > 0) {
		$query = $query . " WHERE $where\n";
	}	
	$rs=execute_query($query);
	while ($row = mysqli_fetch_assoc($rs)) {
		$max = $row['max'];
	}
	return $max;
}

/*
This function updates/creates a new record and returns the id if requested, otherwise will 
return true/false
*/
function insert_update_record($table,$data,$get_id = false) {
    global $DB;
	foreach ($data as $key => $value) {
        $cols[] = "`$key`";
        $values[] = '"'.$value.'"';
		if ($value != NULL) {
            $updateCols[] = "`$key`".' = "'.$value.'"';
        }
    }

	$query = 'INSERT INTO '.$table.' ('.implode(", ", $cols).') VALUES ('.implode(", ",  $values).') ON DUPLICATE KEY UPDATE '.implode(", ", $updateCols);
    	
	$rs=execute_query($query);
	if ($rs){
		if ($get_id){
			return $DB->insert_id;
		}
		else {
			return true;
		}
	}
	else{
		return false;
	} 
}

function insert_multiple_records ($table,$data){
	$new = array();
	$i = 0;
	foreach($data as $idx=>$rows) {	
		$new[] = "'".implode("', '", $rows)."'";
		foreach($rows as $key=>$value) {
			if ($i == 0) {
				$cols[] = "`$key`";
			}
		}
		$i++;
	}
	
	$values = "(".implode("), (", $new).")";
	$query = 'INSERT INTO '. $table .' ('.implode(", ", $cols).') VALUES ' . $values;
	$rs = execute_query($query);
	if ($rs){
		return true;
	}
	else{
		return false;
	}
	
}


function update_record($table,$data,$where) {
    global $DB;
    foreach($data as $key=>$val) {
        $cols[] = "$key = '$val'";
    }
    $query = "UPDATE $table SET " . implode(', ', $cols) . " WHERE $where";
	echo "$query\n\n";
    $rs = execute_query($query);
	if ($rs){
		return true;
	}
	else{
		return false;
	}
}
function insert_upd_records ($table,$data){
$new = array();
	$i = 0;
	foreach($data as $idx=>$rows) {	
		$new[] = "'".implode("', '", $rows)."'";
		
		foreach($rows as $key=>$value) {
			if ($i == 0) {
				$cols[] = "`$key`";
				$upd[] = "$key = VALUES($key)";
			}
			
		}
		$i++;
	}

	$values = "(".implode("), (", $new).")";
	$updates = implode(", ", $upd);
	$query = 'INSERT INTO '. $table .' ('.implode(", ", $cols).') VALUES ' . $values . ' ON DUPLICATE KEY UPDATE ' . $updates;

	$rs = execute_query($query);
	if ($rs){
		return true;
	}
	else{
		return false;
	}

	
}
?>
