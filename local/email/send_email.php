<?php
	
/* 	mysql_connect("localhost", "mailapp", "mailpass") 
	    or die(mysql_error());
	mysql_select_db("test") 
	    or die(mysql_error());
	
	$result = mysql_query("select * from customers")
	    or die(mysql_error());   */
	
	// while ($row = mysql_fetch_array($result)) {
             
	    $headers = "From: rvelez@en-contexto.com\n";
	
	    $subject = "Thank you!";
	
	    $message = "Dear,\n\n"; 
	    $message .= "Thank you for being a loyal customer. " . 
                "Please contact us at 555-4321 for a special discount offer.";
	
	    mail("rafael.velez.c@gmail.com", $subject, $message, $headers);

	    
	    sleep(5);
	//}
	
?>