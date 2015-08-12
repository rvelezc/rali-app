'use strict'

angular.module('theme.calendars', [])
.controller('CalendarController', ['$scope', '$global','Data','$rootScope', function ($scope, $global,Data,$rootScope) {
    var date = new Date();
    var d = date.getDate();
    var m = date.getMonth();
    var y = date.getFullYear();
	$scope.calendarEvents =[
	{
		title: '',
		tooltip: 'All Day Event',
		className: 'completed-task',
		status: 4,
		start: new Date(y, m, 8)
	}
	];
	Data.post('calendar', {
		user: {email: $rootScope.email}
		}).then(function (results) {
		Data.toast(results);
		var d = JSON.parse(results.data);
		if (results.status == "success") {
			for (var i = 0; i < d.length; i++) {
				$scope.$broadcast('addEvent',d[i]);
			}
			
		}
	});
	
    $scope.events = [
		{title: 'FB Event 1', tooltip: 'FB Event 1', className: 'facebook-task'}, 
		{title: 'Email Event 1', tooltip: 'Email Event 1', className: 'email-task'}, 
		{title: 'FB Event 2', tooltip: 'FB Event 2', className: 'facebook-task'}
    ];
    $scope.addEvent = function () {
        $scope.events.push({ title: $scope.newEvent, tooltip: $scope.newEvent, className: 'facebook-task' });
        $scope.newEvent = '';
	};
}])
.directive('fullCalendar', function () {
    return {
		restrict: 'A',
		scope: {
			options: '=fullCalendar'
		},
		link: function (scope, element, attr) {
			var defaultOptions = {
				header: {
					left: 'prev,next today',
					center: 'title',
					right: 'month,agendaWeek,agendaDay'
				},
				selectable: true,
				selectHelper: true,
				select: function(start, end, allDay) {
					var title = prompt('Event Title:');
					if (title) {
						calendar.fullCalendar('renderEvent',
						{
							title: title,
							start: start,
							end: end,
							allDay: allDay
						},
						true // make the event "stick"
						);
					}
					calendar.fullCalendar('unselect');
				},
				eventMouseover: function(calEvent, jsEvent) {
					var tooltip = '<div class="tooltipevent" style="width:100px;height:100px;background:#ccc;position:absolute;z-index:10001;">' + calEvent.tooltip + '</div>';
					$("body").append(tooltip);
					$(this).mouseover(function(e) {
						$(this).css('z-index', 10000);
						$('.tooltipevent').fadeIn('500');
						$('.tooltipevent').fadeTo('10', 1.9);
						}).mousemove(function(e) {
						$('.tooltipevent').css('top', e.pageY + 10);
						$('.tooltipevent').css('left', e.pageX + 20);
					});
				}, 
				
				eventMouseout: function(calEvent, jsEvent) {
					$(this).css('z-index', 8);
					$('.tooltipevent').remove();
				},
				editable: true,
				events: [],
				eventBackgroundColor: 'rgba(0, 0, 0, 0)',
				eventTextColor: '#000000',
				buttonText: {
					prev: '<i class="fa fa-angle-left"></i>',
					next: '<i class="fa fa-angle-right"></i>',
					prevYear: '<i class="fa fa-angle-double-left"></i>',  // <<
					nextYear: '<i class="fa fa-angle-double-right"></i>',  // >>
					today:    'Today',
					month:    'Month',
					week:     'Week',
					day:      'Day'
				}
			};
			$.extend(true, defaultOptions, scope.options);
			if (defaultOptions.droppable == true) {
				defaultOptions.drop = function(date, allDay) {
					var originalEventObject = $(this).data('eventObject');
					var copiedEventObject = $.extend({}, originalEventObject);
					copiedEventObject.title = '';
					copiedEventObject.start = date;
					copiedEventObject.allDay = allDay;
					calendar.fullCalendar('renderEvent', copiedEventObject, true);
					if (defaultOptions.removeDroppedEvent == true)
					$(this).remove();
				}
			}
			//Subscribe to addEvent event
			scope.$on('addEvent', function (event, data) {
				calendar.fullCalendar('renderEvent', data, true);
			});
			
			var calendar = $(element).fullCalendar(defaultOptions);
		}
	};
})
.directive('draggableEvent', function () {
    return {
		restrict: 'A',
		scope: {
			eventDef: '=draggableEvent'
		},
		link: function (scope, element, attr) {
			$(element).draggable({
				zIndex: 999,
				revert: true,
				revertDuration: 0
			});
			$(element).data('eventObject', scope.eventDef);
		}
	};
})
