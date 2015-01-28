#!/usr/bin/php
<?php
require_once('../include/database.php');
global $DB;
global $db_debug;   //Thanks to http://www.daniweb.com/web-development/php/code/434480/using-phpmysqli-with-error-checking for the tip

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

if (count($argv) <= 1) {
    echo "No arguments provided, please provide number of contacts and list(s)\n";
    exit(99);
}


$num_contacts = $argv[1];
$l = $argv[2];

if (is_null($num_contacts) || $num_contacts == '') {
    echo "Please provide a number of contacts to create\n";
    exit(98);
}

if (is_null($l) || $l == '') {
    echo "Please provide a list(s)\n";
    exit(97);
}

// array of possible top-level domains
$tlds = array("com", "net", "gov", "org", "edu", "biz", "info");
$lists = split(",", $l);
$num_lists = count($lists);
// string of possible characters
$char = "0123456789abcdefghijklmnopqrstuvwxyz";
$nums = "0123456789";
$orig_min = get_max_from_table("contact", "id", "") + 1;
$orig_max = $orig_min + $num_contacts;
$batch_limit = 1000;


if ($num_contacts > $batch_limit) {
    $iterations = $num_contacts / $batch_limit;
}

for ($inserts = 0; $inserts < $iterations; $inserts ++) {
    
    $min = $inserts * $batch_limit + $orig_min;
    echo ".";
    if (($min + $batch_limit) > ($orig_max)) 
        $max = $min + $num_contacts % $batch_limit;
    else
        $max = $min + $batch_limit;
    
    $query_contacts = "INSERT INTO contact (id, name, last, email, company, telephone, address, city, state, zip, country, contact_verified, contact_activation_key) VALUES \n";
    $query_lists = "INSERT into list_has_contact (list_id, contact_id) VALUES\n";
    for ($j = $min; $j < $max; $j++) {

        // choose random lengths for the username ($ulen) and the domain ($dlen)
        $name_len = mt_rand(8, 15);
        $last_len = mt_rand(8, 15);
        $dom_len = mt_rand(8, 15);
        $company_len = mt_rand(8, 15);
        $phone_len = 10;
        $street_len = 3;
        $street_name_len = mt_rand(8, 15);
        $city_len = mt_rand(8, 15);
        $zip_len = 5;
        $state_len = 2;
        $activation_len = 10;

        // reset the address
        $name = "";
        $last = "";
        $domain = "";
        $company = "";
        $phone = "";
        $street = "";
        $street_name = "";
        $city = "";
        $zip = "";
        $state = "";
        $activation = "";
        $email = "";


        // get $ulen random entries from the list of possible characters
        // these make up the username (to the left of the @)
        for ($i = 1; $i <= $name_len; $i++)
            $name .= substr($char, mt_rand(0, strlen($char)), 1);
        for ($i = 1; $i <= $last_len; $i++)
            $last .= substr($char, mt_rand(0, strlen($char)), 1);
        for ($i = 1; $i <= $dom_len; $i++)
            $domain .= substr($char, mt_rand(0, strlen($char)), 1);
        for ($i = 1; $i <= $company_len; $i++)
            $company .= substr($char, mt_rand(0, strlen($char)), 1);
        for ($i = 1; $i <= $phone_len; $i++)
            $phone .= substr($nums, mt_rand(0, strlen($nums)), 1);
        for ($i = 1; $i <= $street_len; $i++)
            $street .= substr($nums, mt_rand(0, strlen($nums)), 1);
        for ($i = 1; $i <= $street_name_len; $i++)
            $street_name .= substr($char, mt_rand(0, strlen($char)), 1);
        for ($i = 1; $i <= $city_len; $i++)
            $city .= substr($char, mt_rand(0, strlen($char)), 1);
        for ($i = 1; $i <= $zip_len; $i++)
            $zip .= substr($nums, mt_rand(0, strlen($nums)), 1);
        for ($i = 1; $i <= $state_len; $i++)
            $state .= substr($char, mt_rand(0, strlen($char)), 1);
        for ($i = 1; $i <= $activation_len; $i++)
            $activation .= substr($nums, mt_rand(0, strlen($nums)), 1);


        // wouldn't work so well without this
        $email = "$name.$last@$domain." . $tlds[mt_rand(0, (sizeof($tlds) - 1))];
        $id = $j;
        $query_contacts .= "('$id','$name', '$last', '$email', '$company', '$phone', '$street $street_name', '$city', '$state', '$zip', 'US', '1', '$activation')";
        if ($j < ($max - 1))
            $query_contacts .= ",";
        $query_contacts .= "\n";

        $list = $lists[$j % $num_lists];
        $query_lists .= "('$list','$id')";
        if ($j < ($max - 1))
            $query_lists .= ",";
        $query_lists .= "\n";
    }

    //echo "\n\n\n$query_contacts\n\n\n";
    //echo "$query_lists\n\n";
    $rs = execute_query($query_contacts);
    $rs = execute_query($query_lists);
}

echo ".\n";
?>