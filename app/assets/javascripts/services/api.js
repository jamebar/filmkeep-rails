
angular.module('Api', ['ngResource'])

.factory('Api', ['$q', '$http', '$resource',
    function($q, $http, $resource) {
      var meData = {};

      function getUrl(path) {
        return '/api' + path;
      }

      function build_resource(path, paramDefaults, actions, options) {
        return $resource(getUrl(path), paramDefaults, actions, options);
      }

      return {
        Reviews: build_resource('/reviews/:review_id', null, { update: { method:'PUT' }, 'query':{ method: 'GET'}}),
        Notifications: build_resource('/notifications', null, { markSeen: { method:'post', params:{action: "post"} }, 'query':{ method: 'GET', isArray:true}}),
        Comments: build_resource('/comments/:id', null, { update: { method:'PUT' }, delete: { method:'DELETE', params:{id:'@id'}}, 'query':{ method: 'GET'}}),
        RatingTypes: build_resource('/rating_types/:id', null, { update: { method:'PUT', params:{id:'@id'}}, delete: { method:'DELETE', params:{id:'@id'}}, 'query':{ method: 'GET'}}),
        Users: build_resource('/user/:id', null, { update: { method:'PUT', params:{id:'@id'}}, search: { method:'GET'}, 'query':{ method: 'GET', isArray:true}}),
        Lists: build_resource('/lists/:id', null, {
                'update': {
                  method: 'PUT', 
                  params: {id: '@id'},
                },
                'delete': {
                  method: 'DELETE', 
                  params: {id: '@id'},
                },
                'query': {
                    method: 'GET'
                }
            }),
        addRemoveListItem: function(params){
            return $http({ method: "post", url: "/api/lists/add-remove", params: params }).then( handleSuccess, handleError );
        },
        updateListSortOrder: function(list_id, ordered_ids){
            return $http({ method: "post", url: "/api/lists/sort-order", params: {list_id: list_id, ordered_ids: ordered_ids} }).then( handleSuccess, handleError );
        },
        getWatchlist: function(user_id) {
            return $http({ method: "get", url: "/api/watchlist", params: { action: "get", user_id: user_id } }).then( handleSuccess, handleError );
        },
        addRemoveWatchlist: function(film_id) {
            return $http({ method: "post", url: "/api/watchlist/add-remove", params: { action: "post", film_id: film_id } }).then( handleSuccess, handleError );
        },
        getAggregated: function() {
            return $http({ method: "get", url: "/api/stream", params: { action: "get", type: 'aggregated' } }).then( handleSuccess, handleError );
        },
        getCompares: function(film_id) {
            return $http({ method: "get", url: "/api/compares", params: { action: "get", film_id: film_id } }).then( handleSuccess, handleError );
        },
        me: function(){
            return $http({ method: "get", url: "/api/me", params: { action: "get" } }).then( function(response){
              meData = response.data;
              return( response.data );
            }, handleError );
        },
        meData: function(){
            return meData;
        },
        isAuthorized: function(){
            return $http({ method: "get", url: "/api/user/is_authorized", params: { action: "get"} }).then( handleSuccess, handleError );
        },
        getFilm: function(tmdb_id) {
            return $http({ method: "get", url: "/api/film", params: { action: "get", tmdb_id: tmdb_id } }).then( handleSuccess, handleError );
        },
        getTrailer: function(tmdb_id) {
            return $http({ method: "get", url: "/api/tmdb/trailer/" + tmdb_id, params: { action: "get", tmdb_id: tmdb_id } }).then( handleSuccess, handleError );
        },
        getNowPlaying: function() {
            return $http({ method: "get", url: "/api/tmdb/nowplaying/", params: { action: "get" } }).then( handleSuccess, handleError );
        },
        follow: function(follower_id){
            return $http({ method: "post", url: "/api/follow/" + follower_id, params: { action: "post", follower_id: follower_id} }).then( handleSuccess, handleError );
        },
        unfollow: function(follower_id){
            return $http({ method: "post", url: "/api/unfollow/" + follower_id, params: { action: "post", follower_id: follower_id} }).then( handleSuccess, handleError );
        },
        getFollowers: function(){
            return $http({ method: "get", url: "/api/followers", params: { action: "get"} }).then( handleSuccess, handleError );
        },
        getWtf: function(){
            return $http({ method: "get", url: "/api/wtf", params: { action: "get"} }).then( handleSuccess, handleError );
        }
      }

      function handleError( response ) {
            if (
                ! angular.isObject( response.data ) ||
                ! response.data.message
                ) {

                return( $q.reject( "An unknown error occurred." ) );
            }

            return( $q.reject( response.data.message ) );

        }

        function handleSuccess( response ) {
            return( response.data );
        }
    }
])

;

