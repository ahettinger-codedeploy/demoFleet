$(function () {
    "use strict";

    /* Custom Validation */
    /*alpah numeric only*/
    jQuery.validator.addMethod("alphanumeric", function (value, element) {
        return this.optional(element) || /^[a-zA-Z0-9]+$/.test(value);
    });
    /*alpah numeric dashes and spaces*/
    $.validator.addMethod("nameRegex", function (value, element) {
        return this.optional(element) || /^[a-z0-9\-\s]+$/i.test(value);
    });
    jQuery.validator.addMethod("greaterThan", function (value, element, params) {
        if (!/Invalid|NaN/.test(new Date(value))) {
            return new Date(value) > new Date($(params).val());
        }
        return isNaN(value) && isNaN($(params).val()) || (Number(value) > Number($(params).val()));
    }, 'Must be greater than {0}.');


    /* To do check toggle */
    $(".todo-box li input").on('click', function () {
        $(this).parent().toggleClass('todo-done');
    });
    /* Input switch alternate */
    $('.input-switch-alt').simpleCheckbox();
    /* Enable Hover on dropdown */
    $('.dropdown-toggle').dropdownHover();
    /* Slim scrollbar */
    $('.scrollable-slim').slimScroll({
        color: '#8da0aa',
        size: '10px',
        alwaysVisible: true
    });
    $('.scrollable-slim-sidebar').slimScroll({
        color: '#8da0aa',
        size: '10px',
        height: '100%',
        alwaysVisible: true
    });
    $('.scrollable-slim-box').slimScroll({
        color: '#8da0aa',
        size: '6px',
        alwaysVisible: false
    });
    /* Loading buttons */
    $('.loading-button').click(function () {
        var btn = $(this);
        btn.button('loading');
    });
    /* Tooltips */
    $('.tooltip-button').tooltip({
        container: 'body'
    });
    /* Close response message */
    $('.alert-close-btn').click(function () {
        $(this).parent().addClass('animated fadeOutDown');
    });
    /* Popovers */
    $('.popover-button').popover({
        container: 'body',
        html: true,
        animation: true,
        content: function () {
            var dataID = $(this).attr('data-id');
            return $(dataID).html();
        }
    }).click(function (evt) {
        evt.preventDefault();
    });
    $('.popover-button-default').popover({
        container: 'body',
        html: true,
        animation: true
    }).click(function (evt) {
        evt.preventDefault();
    });
    $('.cd-faq-group').on('click', '.cd-faq-trigger', function (e) {
        e.preventDefault();
        $(this).next('.cd-faq-content').slideToggle(200).end().parent('li').toggleClass('content-visible');
    });

    /* Bootstrap Datepicker */
    $('.bootstrap-datepicker').datepicker({
        autoclose: true
    });
});

//get local user data
var myLocalStorage = {
    set: function (key, value) {
        window.localStorage[key] = value;
    },
    get: function (key, defaultValue) {
        return window.localStorage[key] || defaultValue;
    },
    setObject: function (key, value, expireTimeInSeconds) {
        var item = {
            data: value,
            timestamp: new Date().getTime(),
            expireTimeInMilliseconds: expireTimeInSeconds * 1000
        };
        $window.localStorage[key] = JSON.stringify(item);
    },
    getObject: function (key) {
        var item = JSON.parse(window.localStorage[key] || '{}');
        if (!item || new Date().getTime() > (item.timestamp + item.expireTimeInMilliseconds)) {
            return null;
        } else {
            return item.data;
        }
    },
    reset: function (key) {
        window.localStorage[key] = null;
    }
}

