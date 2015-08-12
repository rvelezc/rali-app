#!/usr/bin/php
<?php
require_once('../include/database.php');
global $DB;
global $db_debug;   //Thanks to http://www.daniweb.com/web-development/php/code/434480/using-phpmysqli-with-error-checking for the tip

$now_date = date('Y-m-d H:i:s');
$future_date = date('Y-m-d H:i:s', strtotime($now_date . '+1 minutes') );
//$now_date = date('Y-m-d H:i:s', strtotime($now_date) );

echo "$now_date\n";
echo "$future_date\n";

	$rs=execute_query("delete from queue");
	$rs=execute_query("delete from transaction");
	$rs=execute_query("delete from batch");
	$rs=execute_query("delete from calendar");
	
	$eml_msg = array (
		'type' => 'email',
		'title' => 'email campaign',
		'from' => 'rafael.velez.c@gmail.com',
		'subject' => 'this is the subject',
		'message' => 'this is the message'
	);
	$eml_msg2 = array (
		'type' => 'email',
		'title' => 'email campaign 2',
		'from' => 'rafael.velez.c@gmail.com',
		'subject' => 'this is the subject 2',
		'message' => 'this is the message 2'
	);
	$fb_msg = array (
		'type' => 'facebook',
		'title' => 'facebook campaign',
		'page_token' => 'CAAEQrGDxRlsBABuLGetdguZAwXUjhu3qSZCi9ewCEIVjWtLuCvsQu2uch8K5hpxBmsthKgO3zqHMLEmgeGOA69zJcXFHW6KfTDi0pt9kbLOYvA4amrmTQFG1b5WIZA3AtbzeoBeLIfaVKTGRhOnULBjmFpFGM9wBScM5WN2Kvxu6fuiZB7ZABZBKb6NAelfRvsyNZBrzK23ZBNCmh8CTB8uOQrIBumrZBcpsZD',
		'page_id' => '731743510279809',
		'picture' => 'http://www.rali-software.com/img/logo.png',
		'link' => 'http://www.rali-software.com',
		'message' => 'Rali Marketing Tool testing',
		'picture' => 'http://www.rali-software.com/img/logo.png',
		'caption' => 'Rali Marketing',
		'description' => 'This is the Description'
	);
	
	$eml_msg_str = base64_encode(serialize($eml_msg));
	$eml_msg_str2 = base64_encode(serialize($eml_msg2));
	$fb_msg_str = base64_encode(serialize($fb_msg));
	//echo "$eml_msg_str\n";
	//echo "$eml_msg_str2\n";
	//echo "$fb_msg_str\n";
	//$eml_msg_str = "TEst1";
	//$eml_msg_str2 = "TEst2";
	//$fb_msg_str = "TEst3";
	
	$query='INSERT INTO `rali_marketing`.`calendar` 
		( 	users_id,calendar_status_id,payload,date_to_process  ) 
		VALUES
		(   1,1,"'. $eml_msg_str .'","'.$now_date.'"),
		(   1,1,"'. $eml_msg_str2 .'","'.$future_date.'"),
        (   1,1,"'. $fb_msg_str .'","'.$now_date.'")
		';
	//echo "$query\n";

	$rs=execute_query($query);
	//echo "$rs\n";

?>
