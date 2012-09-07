angular.module('pursue', ['pursue.services']).
config(['$locationProvider', '$routeProvider',
function($locationProvider, $routeProvider) {
   //$locationProvider.html5Mode(true);
   $locationProvider.hashPrefix('!');

   $routeProvider.when('/', {
      templateUrl: 'partials/home.html',
      controller: HomeController
   });

   $routeProvider.when('/forums', {
      redirectTo: function() {
         window.location.href = 'http://community.teampursue.com';
      }
   });

   $routeProvider.when('/matches', {
      templateUrl: 'partials/matches.html',
      controller: MatchesController
   });

   $routeProvider.when('/roster', {
      templateUrl: 'partials/roster.html',
      controller: RosterController
   });

   $routeProvider.when('/apply', {
      templateUrl: 'partials/apply.html',
      controller: ApplyController
   });

   $routeProvider.when('/about', {
      templateUrl: 'partials/about.html'
   });

   $routeProvider.otherwise({
      redirectTo: '/'
   });

}]);
