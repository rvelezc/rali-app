'use strict'

angular.module('theme.title',  [])
.controller('TitleController', ['$scope','Page', function ($scope,Page) {
    Page.setTitle("Home");

}])	