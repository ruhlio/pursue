angular.module('pursue.services', ['ngResource']).

factory('News', ['$resource', 'Settings', function($resource, Settings) {
   return $resource(Settings.backendUrl + 'news.json', {}, {
      query: { method: 'GET', params: {}, isArray: true }
   });
}]).

factory('Members', ['$resource', 'Settings', function($resource, Settings) {
   return $resource(Settings.backendUrl + 'roster.json', {}, {
      query: { method: 'GET', params: {}, isArray: true }
   });
}]).

factory('Matches', ['$resource', 'Settings', function($resource, Settings) {
   return $resource(Settings.backendUrl + 'matches.json', {}, {
      query: { method: 'GET', params: {}, isArray: true }
   });
}]).

factory('Settings', function() {
   return {
      backendUrl: '/api/'
   };
});
