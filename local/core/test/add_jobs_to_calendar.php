#!/usr/bin/php
<?php
require_once('../include/database.php');
global $DB;
global $db_debug;   //Thanks to http://www.daniweb.com/web-development/php/code/434480/using-phpmysqli-with-error-checking for the tip

$now_date = date('Y-m-d H:i:s');
$future_date = date('Y-m-d H:i:s', strtotime($now_date . '+1 second') );

echo "$now_date\n";
echo "$future_date\n";

	$rs=execute_query("delete from queue");
	$rs=execute_query("delete from transaction");
	$rs=execute_query("delete from batch");
	$rs=execute_query("delete from calendar");
	
	$query='INSERT INTO `rali_marketing`.`calendar` 
		( 	calendar_status_id,batch_id,payload,date_to_process  ) 
		VALUES
		(   1,0,"Job 1","'.$now_date.'"),
		(   1,0,"Job 2","'.$future_date.'"),
        (   1,1,"Job 3","'.$now_date.'"),
        (   1,2,"Job 4",NULL)
		';
	$rs=execute_query($query);

?>