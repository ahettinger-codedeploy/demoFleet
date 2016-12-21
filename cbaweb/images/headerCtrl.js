cbaApp.controller('headerController', function ($scope, $http) {
    getSponsors();

    function getSponsors() {
        $scope.sponsor7 = {};
        $http.get('/Home/GetSponsorSlot/7')
            .then(function (resp) {
                $scope.sponsor7 = resp.data.data;
            }, function (err) {
                console.error('ERR', err);
            });
    }
});

