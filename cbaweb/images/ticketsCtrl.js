cbaApp.controller('ticketsController', function ($scope, $http) {

    $scope.loadingText = "Loading...";

    //get states lookup
    getStatesLookup();
    function getStatesLookup() {
        $http.get('/Resources/GetStatesLookup')
            .then(function (resp) {
                console.log(resp);
                $scope.states = resp.data.data;
            }, function (err) {
                console.error('ERR', err);
            });
    };

    //load types
    $scope.ticketsLoaded = function () {
        
    };

    var onTypeSuccess = function (resp) {
        $scope.recordCount = resp.data.id;
        if ($scope.recordCount > 0) {
            $scope.loadingText = '';
        } else {
            $scope.loadingText = 'Sorry, there are currently no tickets being sold online. Please check back later.';
        }
        $scope.tickets = resp.data.data;
    };

    var onTypeError = function (resp) {
        $scope.error = "Error " + resp.status + ". Could not fetch the data.";
    };

    function getTickets() {
        if (_typeId == 0) {
            $http.get("/Events/GetCurrentTypes")
                .then(onTypeSuccess, onTypeError);
        }
    };

    getTickets();

    //load products
    $scope.productsLoaded = function () {

    };

    var onProductSuccess = function (resp) {
        $scope.recordCount = resp.data.id;
        $scope.products = resp.data.data;
    };

    var onProductError = function (resp) {
        $scope.error = "Error " + resp.status + ". Could not fetch the data.";
    };

    function getProducts() {
        if (_typeId > 0) {
            $http.get("/Events/GetProducts/" + _typeId)
                .then(onProductSuccess, onProductError);
        }
    };

    getProducts();

    //submit order click
    $scope.submitOrder = function() {
        var $form = $('#')
    };

});

