<?php

/*
This function executes a query
*/
function echo_ts($source,$pid,$str) {
	$ts=date('m-d-Y H:i:s');
	echo "$ts: $pid: $source: $str\n";
}

	
?>
