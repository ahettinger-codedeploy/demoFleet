//(function () {
//    'use strict';

angular.module('cbaApp.factories', [])
    .factory('$localstorage', ['$window', function($window) {
            return {
                set: function(key, value) {
                    $window.localStorage[key] = value;
                },
                get: function(key, defaultValue) {
                    return $window.localStorage[key] || defaultValue;
                },
                setObject: function(key, value, expireTimeInSeconds) {
                    var item = {
                        data: value,
                        timestamp: new Date().getTime(),
                        expireTimeInMilliseconds: expireTimeInSeconds * 1000
                    };
                    $window.localStorage[key] = JSON.stringify(item);
                },
                getObject: function(key) {
                    var item = JSON.parse($window.localStorage[key] || '{}');
                    if (!item || new Date().getTime() > (item.timestamp + item.expireTimeInMilliseconds)) {
                        return null;
                    } else {
                        return item.data;
                    }
                },
                reset: function(key) {
                    $window.localStorage[key] = null;
                }
            }
        }
    ])
    .factory('$imagecache', ['$q', '$timeout', function($q, $timeout) {
        return {
            Cache: function(urls) {
                var promises = [];
                for (var i = 0; i < urls.length; i++) {
                    var deferred = $q.defer();
                    var img = new Image();

                    img.onload = (function(deferred) {
                        return function() {
                            deferred.resolve();
                        }
                    })(deferred);

                    img.onerror = (function(deferred, url) {
                        return function() {
                            deferred.reject(url);
                        }
                    })(deferred, urls[i]);

                    promises.push(deferred.promise);
                    img.src = urls[i];
                }
                return $q.all(promises);
            }
        }
    }])
    .factory('$sendemail', ['$http', function($http) {
        var url = '/Scripts/email.php';
        return {
            phpPost: function (data) {
                return $http.post(url, data);
            }
        }
    }])
    .factory('$searchcities', ['$http', '$cacheFactory', function($http, $cacheFactory) {
        return {
            get: function(payload, successCallback){
                var key = 'search_' + payload.q;
                if($cacheFactory.get(key) == undefined || $cacheFactory.get(key) == ''){
                    $http.get('/Events/GetCitiesLookup', { params: payload }).then(function (resp) {
                        $cacheFactory(key).put('result', resp.data.data);
                        successCallback(resp.data.data);
                    });
                }else{
                    successCallback($cacheFactory.get(key).get('result'));
                }
            }
        }
    }]);

//})();