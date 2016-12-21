angular.module('cbaApp.filters', [])
    .filter('encodeURIComponent', function() {
        return window.encodeURIComponent;
    })
    .filter('dateFromJson', function() {
        return function(dateString) {
            return moment(dateString).add('days', 1).format('M/D/YYYY');
        };
    })
    .filter('dateFromUnix', function() {
        return function(value) {
            return moment.unix(value).format('M/D/YYYY');
        };
    })
    .filter('dateDayOfWeek', function() {
        return function (dateString) {
            return moment(dateString).format('dddd');
        };
    })
    .filter('numWithComma', function() {
        return function(num) {
            try {
                if (num.toString().length > 3) {
                    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                } else {
                    return num;
                }
            } catch (err) {
                return num;
            }
        }
    })
    .filter('shortenString', function () {
        return function (str, num) {
            var shortStr = str;
            if (shortStr.length > num) shortStr = shortStr.substring(0, num) + "...";
            return shortStr;
        };
    })
    .filter('trueFalseCheckbox', function ($sce) {
        return function (value) {
            if (value) {
                return $sce.trustAsHtml('<i class="fa fa-check-square-o fa-2x"></i>');
            } else {
                return $sce.trustAsHtml('<i class="fa fa-square-o fa-2x"></i>');
            }
        };
    })
    .filter('range', function () {
        return function (input, start, end) {
            start = parseInt(start);
            end = parseInt(end);
            var direction = (start <= end) ? 1 : -1;
            while (start != end) {
                input.push(start);
                if (direction < 0 && start == end + 1) {
                    input.push(end);
                }
                if (direction > 0 && start == end - 1) {
                    input.push(end);
                }
                start += direction;
            }
            return input;
        };
    })
    .filter('rawHtml', ['$sce', function ($sce) {
        return function (val) {
        return $sce.trustAsHtml(val);
    };
}]);




    