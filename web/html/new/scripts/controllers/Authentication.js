angular.module('Authentication', [])
.controller('AuthenticationController', function ($scope, $rootScope, $routeParams, $location, $http, Data, $global) {
    //initially set those objects to null to avoid undefined error
    $scope.login = {};
    $scope.signup = {};
	$global.set('fullscreen', true);
	
    $scope.$on('$destroy', function () {
		$global.set('fullscreen', false);
	});
	
    $scope.doLogin = function (user) {
        Data.post('login', {
            user: user
			}).then(function (results) {
            Data.toast(results);
            if (results.status == "success") {
                $location.path('');
			}
		});
	};
    $scope.signup = {email:'',password:'',name:'',phone:'',address:''};
    $scope.signUp = function (user) {
        Data.post('signUp', {
            user: user
			}).then(function (results) {
            Data.toast(results);
            if (results.status == "success") {
                $location.path('');
			}
		});
	};
});