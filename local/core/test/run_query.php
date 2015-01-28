#!/usr/bin/php
<?php
require_once('../include/database.php');

if (count($argv) <= 1) {
    echo "No arguments provided, please provide query and optionally sleep time and iterations\n";
    exit(99);
}

$iterations = null;
$sleep_time = $argv[1];
if (count($argv) > 2) $iterations = $argv[2];

if (is_null($sleep_time) || $sleep_time == '') {
    echo "Sleep time not provided, using default 10 sec\n";
    $sleep_time = 10;
}


$query = "select name,(processed / record_count) * 100 as percentage, date_created, date_modified from batch";
//$query = "select * from calendar";

while ($iterations > 0 || is_null($iterations)){
    $rs=execute_query($query);
    echo "---------------------------------------------------------------------\n";
    echo "QUERY: \n\n$query\n\nRESULT:\n\n";
    while ($row = $rs->fetch_assoc()) {
        print_r($row);
    }
    $iterations--;
    if ($iterations > 0 || is_null($iterations)) sleep($sleep_time);  //dont sleep last iteration
    
    
}

?>