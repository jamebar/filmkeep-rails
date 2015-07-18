'use strict';

angular.module('Filters',[])

.filter('unsafe', function($sce) {
    return function(val) {
        return $sce.trustAsHtml(val);
    };

})

.filter('imageFilter', [ function() {
  return function(path, type, size)
  {
    if(!path)
      return '/img/fallback-poster.jpg';

    var image_config = image_path_config;
    
    var s = size || 0;
    var t = type || 'poster';

    return image_config.base_url + image_config[type + '_sizes'][size] +  path;

  }
    
}])

.filter('profileFilter', [ function() {
  return function(path)
  {
    var p = path || '/img/default-profile.jpg';
    return p;

  }
    
}])

.filter('verb',function(){
  return function(verb){
    var keys = {'filmkeep\\review':'reviewed',
                'filmkeep\\watchlist':'added',
                'filmkeep\\comment':'commented',
                'filmkeep\\customlist':'created',
                'filmkeep\\follower':'started following'
                };
    return _.find(keys, function(v,k){
      return k.indexOf(verb.toLowerCase()) > -1
    });
  }
})
