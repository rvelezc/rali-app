'use strict'

angular.module('theme.settings',  [])
.controller('SettingsController', ['$scope', function ($scope) {
	$scope.authResponse = {};
	$scope.userInfo = {};
	$scope.pages = {};
	
	(function (d, s, id) {
		var js, fjs = d.getElementsByTagName(s)[0];
		if (d.getElementById(id))
		return;
		js = d.createElement(s);
		js.id = id;
		js.src = "//connect.facebook.net/en_US/sdk.js";
		fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));
	//Initialize Facebook SDK
	window.fbAsyncInit = function () {
		FB.init({
			appId: '299807523554907',
			cookie: true, // enable cookies to allow the server to access 
			// the session
			xfbml: true, // parse social plugins on this page
			version: 'v2.1' // use version 2.1
		});
	}
	
	$scope.fb_login = function () {
		FB.login(function (response) {
			//console.log(response);
			if (response.authResponse) {
				console.log('Welcome!  Fetching your information.... ');
				//console.log(response); // dump complete info
				$scope.authResponse = response.authResponse; //get access token
							
				FB.api('/me', function (response) {
					console.log("Retrieving user info");
					$scope.userInfo = response;
					//console.log($scope.userInfo);
					FB.api('/me/accounts', function(response){ 
						$scope.pages = response; 
						console.log($scope.authResponse);
						console.log($scope.userInfo);
						console.log($scope.pages);
					});
					
					
					
					/* $.post(
						"api/v1/fb_login",
						user_data,
						function (data) {
						if (data.error === false) {
						$.session.set('name', data.name);
						$.session.set('apiKey', data.apiKey);
						$.session.set('last', data.last);
						//Check if user wants to have a cookie
						if ($('#signInRemember').is(':checked')) {
						$.cookie('tc_name', data.name, {expires: 365});
						$.cookie('tc_last', data.last, {expires: 365});
						$.cookie('tc_api', data.apiKey, {expires: 365});
						}
						$('#signin-signup-dialog').modal('hide');
						setLoginLogout(false);
						if ($('#collapse-menu').hasClass('in')) {
						$(".navbar-toggle").trigger("click");
						}
						}
						else {
						html_content = "<p>" + data.message + "</p>";
						if (data.error === false)
						html_lbl = "Confirmation:";
						else
						html_lbl = "Error:";
						openSignDialog(html_lbl, html_content);
						}
						}
					); */
				});
				
				
			} //else {
            //user hit cancel button
            //console.log('User cancelled login or did not fully authorize.');
		//}
		}, {
        scope: 'public_profile,email,manage_pages,publish_actions'
	});
}





}])	