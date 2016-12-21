cbaApp.controller('sponsorController', function ($scope, $http) {
    getSponsors();

    function getSponsors() {
        $scope.sponsor1 = {};
        $scope.sponsor2 = {};
        $scope.sponsor3 = {};
        $http.get('/Home/GetSponsorSlot/1')
            .then(function (resp) {
                $scope.sponsor1 = resp.data.data;
            }, function (err) {
                console.error('ERR', err);
            });
        $http.get('/Home/GetSponsorSlot/2')
            .then(function (resp) {
                $scope.sponsor2 = resp.data.data;
            }, function (err) {
                console.error('ERR', err);
            });
        $http.get('/Home/GetSponsorSlot/3')
            .then(function (resp) {
                $scope.sponsor3 = resp.data.data;
            }, function (err) {
                console.error('ERR', err);
            });
    }
});

