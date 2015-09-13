
  'use strict';

  angular.module('fk.comments', [
])

  .directive('comments', ['Api','$timeout','growl',
    function(Api, $timeout, growl){
        return {
            restrict: 'E',
            scope:{
              type : '@',
              commentableId: '=',
              filmId: '=',
            },
            templateUrl: 'comments/comments.tmpl.html',
            link: function(scope, element, attrs) {
              scope.flag = false;

              $timeout(function() {
                element.find('.comment_input').focus();
              });

              if (scope.type.indexOf('Filmkeep') > -1) {
                scope.type = scope.type.split('\\')[1].toLowerCase();
              };
              
              Api.Comments.query({type: scope.type, type_id: scope.commentableId}, function(response){
                scope.comments = response;
              });
              scope.bootstrap = Api.meData();

              scope.newComment = function(){
                scope.comment = new Api.Comments();
              }
              
              scope.addComment = function(){
                scope.flag = true;
                scope.comment.type = scope.type;
                scope.comment.type_id = scope.commentableId;
                scope.comment.film_id = scope.filmId;
                scope.comment.$save(function(response){
                  growl.success("Your comment has been added.")
                  scope.comments.push(scope.comment)
                  scope.newComment();
                  scope.flag = false;
                },function(response){
                  growl.error("Whoops, make sure you type a comment.");
                  scope.flag = false;
                })
              }

              scope.deleteComment = function(c){
                var resource = new Api.Comments();
                resource.id = c.id;

                resource.$delete(function(response){
                  scope.comments = _.reject(scope.comments, function(com){
                    return com.id == c.id;
                  })
                  growl.success("Your comment has been deleted.");
                });
              }

              scope.newComment();

            }

        }
    }
  ])

  .directive('commentsForm', ['Api',
    function(Api){
        return {
            restrict: 'E',
            templateUrl: 'comments/comment_form.tmpl.html',
            link: function(scope, element, attrs) {

            }

        }
    }
  ]);