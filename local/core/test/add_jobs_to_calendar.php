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
		( 	campaign_id,list_id,calendar_status_id,content_id,user_id,batch_id,name,description,date_to_process  ) 
		VALUES
		(   1,1,1,1,1,0,"Job 1","Desc for Job 1","'.$now_date.'"),
		(   9,3,1,3,2,0,"Job 2","Desc for Job 2","'.$future_date.'"),
                (   8,2,1,3,2,0,"Job 3","Desc for Job 3","'.$now_date.'"),
                (   9,3,1,3,2,0,"Job 4","Desc for Job 4",NULL)
		';
	$rs=execute_query($query);

?>