
  'use strict';

  angular.module('settings', [
  ])

  .config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
    $stateProvider.state('root.settings', {
      abstract: true,
      url: '/settings',
      title: 'Settings',
      views: {
        'page' : {
          templateUrl: 'settings/settings.tmpl.html',
          controller: 'settingsCtrl'
        }
      },
      resolve: {
        isAuthorized: function (Api) {
            return Api.isAuthorized();
        } 
      },
      onEnter: function(isAuthorized){
        if(isAuthorized == 0)
          window.location.href = '/users/login';
      }
    });

    $stateProvider.state('root.settings.profile', {
      url: '/profile',
      title: 'Settings - profile',
      views: {
        'page-child' : {
          templateUrl: 'settings/profile.tmpl.html',
          controller: 'settingsProfileCtrl'
        }
      },
    });
    $stateProvider.state('root.settings.filmeters', {
      url: '/filmeters',
      title: 'Settings - sliders',
      views: {
        'page-child' : {
          templateUrl: 'settings/filmeters.tmpl.html',
          controller: 'settingsFilmetersCtrl'
        }
      },
    });

  }])

  .controller('settingsCtrl', ['$scope','bootstrap','growl','$state','Api',
    function ($scope, bootstrap,growl,$state,Api) {

      $scope.current_user = new Api.Users();
        _.assign($scope.current_user, bootstrap.me);
        
      $scope.tabs = [
        {title: 'Profile', state:'root.settings.profile', active:false},
        {title: 'Sliders', state:'root.settings.filmeters', active:false}
      ];

      _.forEach($scope.tabs, function(tab){
        if($state.includes(tab.state))
          tab.active = true;
      });

      $scope.gotoTab = function(dest){
        $state.go(dest);
      }

  }]) 

  .controller('settingsProfileCtrl', ['$scope','bootstrap','growl','msgBus',
    function ($scope, bootstrap,growl,msgBus) {
        msgBus.emitMsg('pagetitle::change', "Settings: Profile");

        $scope.saveUser = function(){
          $scope.current_user.$update(function(response){
              growl.success("Your changes have been saved");
              _.assign(bootstrap.me, response);
          },function(response_headers){
              growl.warning(response_headers.headers('X-API-MESSAGE'));
          });
        }

  }]) 

  .controller('settingsInvitesCtrl', [
    function () {


  }]) 

  .controller('settingsFilmetersCtrl', ['$scope','bootstrap','growl','ReviewService','msgBus','Api',
    function ($scope, bootstrap,growl,ReviewService,msgBus,Api) {
        msgBus.emitMsg('pagetitle::change', "Settings: Sliders");
        

  }]) 

  .directive('pwCheck', [function () {
        return {
            require: 'ngModel',
            link: function (scope, elem, attrs, ctrl) {
                var firstPassword = '#' + attrs.pwCheck;
                elem.add(firstPassword).on('keyup', function () {
                    scope.$apply(function () {
                        var v = elem.val()===$(firstPassword).val();
                        ctrl.$setValidity('pwmatch', v);
                    });
                });
            }
        }
    }])
   
   .directive('ngReallyClick', ['$modal',
        function($modal) {

          var ModalInstanceCtrl = function($scope, $modalInstance) {
            $scope.ok = function() {
              $modalInstance.close();
            };

            $scope.cancel = function() {
              $modalInstance.dismiss('cancel');
            };
          };

          return {
            restrict: 'A',
            scope: {
              ngReallyClick:"&"
            },
            link: function(scope, element, attrs) {
              element.bind('click', function() {
                var message = attrs.ngReallyMessage || "Are you sure ?";

                var modalHtml = '<div class="modal-body"><p>' + message + '</p></div>';
                modalHtml += '<div class="modal-footer"><button class="btn btn-success" ng-click="ok()">OK</button><button class="btn btn-default" ng-click="cancel()">Cancel</button></div>';

                var modalInstance = $modal.open({
                  template: modalHtml,
                  controller: ModalInstanceCtrl,
                  size:'sm'
                });

                modalInstance.result.then(function() {
                  scope.ngReallyClick();
                }, function() {
                  //Modal dismissed
                });
                
              });

            }
          }
        }
      ])

  
  ;
