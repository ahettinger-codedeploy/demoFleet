var cbaApp = angular.module('cbaApp', ['ngAnimate', 'cbaApp.directives', 'cbaApp.filters', 'cbaApp.factories', 'angular-jquery-validate', 'angular-bootbox', 'ngFileUpload', 'ui.footable', 'angularMoment'])
    .run(function ($http, $timeout, $window, $localstorage) {

        //reset active nav li
        $("#main-nav .navbar-nav").find("li").each(function() {
            $(this).removeClass("active");
        });

        //get curent page url
        var currentpage = $window.location.pathname;
        if (currentpage.length === 0 || currentpage === "/") {
            currentpage = '';
        }
        if (currentpage.substr(-1) == '/') {
            return currentpage.substr(0, currentpage.length - 1);
        }
        currentpage = currentpage.toLowerCase();
        currentpage = currentpage.replace('/index', '');

        //set active nav li
        switch (currentpage) {
        case (currentpage.match(/^\/about/) || {}).input:
            $('#navabout').addClass('active');
            break;
        case (currentpage.match(/^\/members/) || {}).input:
            $('#navabout').addClass('active');
                break;
        case (currentpage.match(/^\/learning/) || {}).input:
            $('#navlearning').addClass('active');
            break;
        case (currentpage.match(/^\/resources/) || {}).input:
            $('#navresources').addClass('active');
            break;
        case (currentpage.match(/^\/events/) || {}).input:
            $('#navevents').addClass('active');
            break;
        case (currentpage.match(/^\/messageboard/) || {}).input:
            $('#navmessageboard').addClass('active');
            break;
        case (currentpage.match(/^\/galleries/) || {}).input:
            $('#navgallaries').addClass('active');
            break;
        default:
            $('#navhome').addClass('active');
            break;
        }

        //check message board login
        if ($localstorage.getObject('mbLogin') == null) {
            mbLogin = null;
        } else {
            mbLogin = $localstorage.getObject('mbLogin');
        }

        //load banner
        $http.get('/Home/GetBanner')
            .then(function (resp) {
                $('.banner').attr('src', "/Images/banners/" + resp.data.data);
            }, function (err) {
                console.error('ERR', err);
            });
    })

    //configure jquery validation plugin and locationProvider
    .config(function ($jqueryValidateProvider) {

        $jqueryValidateProvider.setDefaults({
            highlight: function (element) {
                $(element).closest('.form-group').addClass('has-error');
            },
            unhighlight: function (element) {
                $(element).closest('.form-group').removeClass('has-error');
            },
            errorElement: 'span',
            errorClass: 'help-block',
            errorPlacement: function (error, element) {
                if (element.parent('.input-group').length) {
                    error.insertBefore(element.parent());
                } else {
                    error.insertBefore(element);
                }
            },
            showErrors: function (errorMap, errorList) {
                this.defaultShowErrors();
            }
        });
    });
