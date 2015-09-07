
  'use strict';

  angular.module('feed', [
  ])

.config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {

    $stateProvider.state('root.feed', {
      url: '/feed',
      title: 'feed',
      views: {
        'page' : {
          templateUrl: 'home.tmpl.html',
          controller: 'feedCtrl'
        }
      },
      resolve: {
        isAuthorized: ['Api', function (Api) {
            return Api.isAuthorized();
        }] 
      },
      onEnter: function(isAuthorized){
        if(isAuthorized == 0)
          window.location.href = '/users/login';
      }
    });
  }])

.controller('feedCtrl', ['$scope', 'msgBus','bootstrap', 'ReviewService','Api','$state',
  function($scope, msgBus, bootstrap, ReviewService, Api, $state){
    msgBus.emitMsg('pagetitle::change', 'My Feed' );
    $scope.loading = true;
    $scope.me = bootstrap.me;
    $scope.announcements = bootstrap.announcements;
    var client = stream.connect(bootstrap.stream.key, null, bootstrap.stream.id);
    var stream_user = client.feed('aggregated', bootstrap.me.id, bootstrap.stream.agg_token);

    stream_user.subscribe(function(data){
      console.log(data)
    })

    ReviewService.getRatingTypes().then(function(results){
      $scope.rating_types_new = results;
        
    });

    

    Api.getNowPlaying().then(function(response){
      $scope.now_playing = response;
    })

    Api.getWatchlist(bootstrap.me.id).then(function(response) {
                $scope.watchlist_items = response;
            });

    $scope.getVerb = function(v)
    {
      return v.split('\\').pop().toLowerCase();
    }

    $scope.releaseDate = function(d){
      return moment(d).format('YYYY');
    }

    
    var getFeed = function () {
        Api.getAggregated()
            .then(
              function(response){
                $scope.feed_items = response;
                $scope.loading = false;
            });
    };
    

    $scope.toPercent = function(num){
        return (num/2000 * 100) + '%';
    }

    $scope.openComments = function(obj){
      if(obj.commentable_type == 'Review')
        $state.go('root.review', {reviewId: obj.commentable_id });
      else
        $scope.watchlistModal(obj);
    }

    getFeed();
  }])

.directive('feedItems', [
  function(){
    return {
      restrict: 'E',
      templateUrl: 'feed/feed_items.tmpl.html',
      link: function(scope,element,attr){

      }
    }
}])

.filter('fDate',function(){
  return function(date){
    moment.locale('en', {
      relativeTime : {
          future: "in %s",
          past:   "%s ago",
          s:  "seconds",
          m:  "1min",
          mm: "%dmins",
          h:  "1h",
          hh: "%dh",
          d:  "1d",
          dd: "%dd",
          M:  "1mon",
          MM: "%dm",
          y:  "1y",
          yy: "%dy"
      }
    });
    if (date == null) return '';
    return moment.utc(date).fromNow(true);
  }
})