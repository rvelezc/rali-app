<?php
	
	function send_email($payload) {
		$r = array (
		'error' => '1',
		'response' => "Email not sent"
		);
		$headers = "From: " . $payload['from'] . "\n";
		$subject = $payload['subject'];
		$message = $payload['message']; 
	    $res=mail("rafael.velez.c@gmail.com", $subject, $message, $headers);
		sleep(1);
		
		if ($res){
			$r['error'] = '0';
			$r['response'] = "Success";
		}
		return $r;
	}
	//}
	
?>