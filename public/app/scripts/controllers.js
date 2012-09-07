function IndexController($scope, $http) {
   $http.get('fixtures/navigationLinks.json')
        .success(function(navLinks) {
      $scope.navigationLinks = navLinks;
   });
}
IndexController.$inject = ['$scope', '$http'];

function HomeController($scope, News, Matches) {
   $scope.news = News.query();

   $scope.matches = Matches.query();
}
HomeController.$inject = ['$scope', 'News', 'Matches'];

function MatchesController($scope, Matches) {
}
MatchesController.$inject = ['$scope', 'Matches'];

function RosterController($scope, Members) {
   $scope.members = Members.query();
}
RosterController.$inject = ['$scope', 'Members'];

function ApplyController($scope, ClanApplication) {

}
ApplyController.$inject = ['$scope', 'ClanApplication'];
