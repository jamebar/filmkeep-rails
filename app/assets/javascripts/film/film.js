
  'use strict';

  angular.module('film', [
  ])

  .config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
    $stateProvider.state('root.film', {
      url: '/f/{filmId}-{filmSlug}',
      title: 'Film',
      views: {
        'page' : {
          templateUrl: 'film.tmpl.html',
          controller: 'FilmCtrl'
        }
      },
      resolve: {
        FilmLoad:['$stateParams','Api', function($stateParams,Api) {
          return Api.getFilm($stateParams.filmId);
        }], 
      }
    });
  }])

  .controller('FilmCtrl', ['$scope', 'msgBus','$stateParams','bootstrap','FilmLoad',
    function ($scope,msgBus,$stateParams,bootstrap,FilmLoad) {
        msgBus.emitMsg('pagetitle::change', FilmLoad.title );
        $scope.me = bootstrap.me;
        FilmLoad.film_id = FilmLoad.id;
        $scope.film = FilmLoad;
        $scope.follower_reviews = FilmLoad.follower_reviews;

        $scope.$on('watchlist::addremove', function(event, film_id) {

          $scope.film.on_watchlist = $scope.film.on_watchlist === 'true' ? 'false' : 'true';
                
        });

    }]) 

  
  ;
