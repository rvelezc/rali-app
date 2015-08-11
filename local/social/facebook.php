<?php
	
	function send_message ($payload) {
		
		$result = array (
		'error' => '1',
		'response' => "Message not sent"
		);
		if ( $payload['type'] == "facebook" ) {
			$page_access_token = $payload['page_token'];
			$page_id = $payload['page_id'];
			$data['picture'] = $payload['picture'];
			$data['link'] = $payload['link'];
			$data['message'] = $payload['message'];
			$data['caption'] = $payload['caption'];
			$data['description'] = $payload['description'];;
			$data['access_token'] = $page_access_token;
			$post_url = 'https://graph.facebook.com/'.$page_id.'/feed';
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_URL, $post_url);
			curl_setopt($ch, CURLOPT_POST, 1);
			curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
			$return = curl_exec($ch);
			//$return = "Yeahhh";
			curl_close($ch);
			$result['response']=$return;	
		}
		return $result;
	}
	
	
	
	
?>

