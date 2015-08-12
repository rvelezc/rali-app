<?php 
	
	$app->post('/calendar', function() use ($app) {
		$response = array();
		$data = array();
		$r = json_decode($app->request->getBody());
		verifyRequiredParams(array('email'),$r->user);
		$db = new DbHandler();
		$email = $r->user->email;
		$user = $db->getOneRecord("select uid from users where email='$email'");
		if ($user != NULL) {
			$uid = $user['uid'];
			$events = $db->getRecords("select users_id, payload, date_to_process, calendar_status_id from calendar where users_id='$uid'");
			if($events->num_rows > 0){
				while ($row = $events->fetch_assoc()) {
					$payload = unserialize(base64_decode($row['payload']));
					$class = $payload['type']."-task";
					if ($row['calendar_status_id'] == 4) $class = "completed-task";
					$record = array (
						'title' => '',
						'tooltip' => $payload['title'],
						'type' => $payload['type'],
						'start' => $row['date_to_process'],
						'status' => $row['calendar_status_id'],
						'className' => $class
					);
					array_push($data, $record);
				}
				$response['data'] = json_encode($data);
			} 
			else {
				$response['data'] = "";
			}
			$response['status'] = "success";
			$response['message'] = "Calendar events loaded successfully";
			echoResponse(200, $response);
		} else {
            $response['status'] = "error";
            $response['message'] = 'User not found';
			echoResponse(201, $response);
		}
		
		
	});
	
?>