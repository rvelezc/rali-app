<?php 
$app->get('/session', function() {
    $db = new DbHandler();
    $session = $db->getSession();
    $response["uid"] = $session['uid'];
    $response["email"] = $session['email'];
    $response["name"] = $session['name'];
    echoResponse(200, $session);
});
$app->post('/login', function() use ($app) {
    require_once 'passwordHash.php';
    $r = json_decode($app->request->getBody());
    verifyRequiredParams(array('email', 'password'),$r->user);
    $response = array();
    $db = new DbHandler();
    $password = $r->user->password;
    $email = $r->user->email;
    $user = $db->getOneRecord("select uid,name,password,email,created from users where phone='$email' or email='$email'");
    if ($user != NULL) {
        if(passwordHash::check_password($user['password'],$password)){
        $response['status'] = "success";
        $response['message'] = 'Logged in successfully.';
        $response['name'] = $user['name'];
        $response['uid'] = $user['uid'];
        $response['email'] = $user['email'];
        $response['createdAt'] = $user['created'];
        if (!isset($_SESSION)) {
            session_start();
        }
        $_SESSION['uid'] = $user['uid'];
        $_SESSION['email'] = $email;
        $_SESSION['name'] = $user['name'];
        } else {
            $response['status'] = "error";
            $response['message'] = 'Login failed. Incorrect credentials';
        }
    }else {
            $response['status'] = "error";
            $response['message'] = 'No such user is registered';
        }
    echoResponse(200, $response);
});
$app->post('/signUp', function() use ($app) {
    $response = array();
    $r = json_decode($app->request->getBody());
    verifyRequiredParams(array('email', 'name', 'password'),$r->user);
    require_once 'passwordHash.php';
    $db = new DbHandler();
    $phone = $r->user->phone;
    $name = $r->user->name;
    $email = $r->user->email;
    $address = $r->user->address;
    $password = $r->user->password;
	
	//Check if user exists
    $isUserExists = $db->getOneRecord("select 1 from users where email='$email'");
    if(!$isUserExists){
	
		//Create user on DB
        $r->user->password = passwordHash::hash($password);
        $tabble_name = "users";
        $column_names = array('phone', 'name', 'email', 'password', 'city', 'address');
        $result = $db->insertIntoTable($r->user, $column_names, $tabble_name);
        if ($result != NULL) {
            //User Created, now create DB authentication record
			$random_str = sha1($user['name'] . date('Y-m-d H:i:s') . $user['id']);
			if ($db->newAccountRequest($random_str, $user['id'])) {
				//Authorization record created, now send email
				if ($em->send_account_act_email($user['email'], $random_str)) {
					$response["status"] = "success";
					$response['URL'] = BASE_URL . "/#/activate_account/" . $random_str;
					$response["message"] = "User account created successfully, a confirmation email with instructions to activate your account has been sent";
					echoResponse(200, $response);
				} else {
					$response['status'] = "error";
					$response["message"] = "An error occurred while sending activation email";
					echoResponse(201, $response);
				}
				
			} else {
				$response['status'] = "error";
				$response["message"] = "An error occurred while registering";
				echoResponse(201, $response);
			}
        } else {
            $response["status"] = "error";
            $response["message"] = "Failed to create user. Please try again";
            echoResponse(201, $response);
        }            
    }else{
        $response["status"] = "error";
        $response["message"] = "An user with the provided email exists!";
        echoResponse(201, $response);
    }
});
$app->post('/signUpOriginal', function() use ($app) {
    $response = array();
    $r = json_decode($app->request->getBody());
    verifyRequiredParams(array('email', 'name', 'password'),$r->user);
    require_once 'passwordHash.php';
    $db = new DbHandler();
    $phone = $r->user->phone;
    $name = $r->user->name;
    $email = $r->user->email;
    $address = $r->user->address;
    $password = $r->user->password;
    $isUserExists = $db->getOneRecord("select 1 from users where email='$email'");
    if(!$isUserExists){
        $r->user->password = passwordHash::hash($password);
        $tabble_name = "users";
        $column_names = array('phone', 'name', 'email', 'password', 'city', 'address');
        $result = $db->insertIntoTable($r->user, $column_names, $tabble_name);
        if ($result != NULL) {
            $response["status"] = "success";
            $response["message"] = "User account created successfully";
            $response["uid"] = $result;
            if (!isset($_SESSION)) {
                session_start();
            }
            $_SESSION['uid'] = $response["uid"];
            $_SESSION['phone'] = $phone;
            $_SESSION['name'] = $name;
            $_SESSION['email'] = $email;
            echoResponse(200, $response);
        } else {
            $response["status"] = "error";
            $response["message"] = "Failed to create customer. Please try again";
            echoResponse(201, $response);
        }            
    }else{
        $response["status"] = "error";
        $response["message"] = "An user with the provided phone or email exists!";
        echoResponse(201, $response);
    }
});
$app->get('/logout', function() {
    $db = new DbHandler();
    $session = $db->destroySession();
    $response["status"] = "info";
    $response["message"] = "Logged out successfully";
    echoResponse(200, $response);
});
?>