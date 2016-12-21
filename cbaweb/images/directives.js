angular.module('cbaApp.directives', [])
    .directive('imageonload', function() {
        return {
            restrict: 'A',
            link: function(scope, element, attrs) {
                element.bind('load', function() {
                    console.log('image is loaded');
                });
            }
        };
    })
    .directive('enterSubmit', function() {
        return {
            restrict: 'A',
            link: function(scope, elem, attrs) {
                elem.bind('keydown', function(event) {
                    var code = event.keyCode || event.which;
                    if (code === 13) {
                        if (!event.shiftKey) {
                            event.preventDefault();
                            scope.$apply(attrs.enterSubmit);
                        }
                    }
                });
            }
        }
    })
    .directive('a', function () {
        return {
            restrict: 'E',
            link: function (scope, elem, attrs) {
                if (attrs.ngClick || attrs.href === '' || attrs.href === '#') {
                    elem.on('click', function (e) {
                        e.preventDefault();
                    });
                }
            }
        };
    })
    .directive('modal', function() {
        return {
            template: '<div class="modal fade" data-keyboard="{{ keyboard }}" data-backdrop="{{ backdrop }}">' +
                '<div class="modal-dialog">' +
                '<div class="modal-content">' +
                '<div class="modal-header">' +
                '<button type="button" class="close" style="display:{{ hideClose }};" data-dismiss="modal" aria-hidden="true">&times;</button>' +
                '<h4 class="modal-title">{{ title }}</h4>' +
                '</div>' +
                '<div class="modal-body" ng-transclude></div>' +
                '</div>' +
                '</div>' +
                '</div>',
            restrict: 'E',
            transclude: true,
            replace: true,
            scope: true,
            link: function postLink(scope, element, attrs) {
                scope.title = attrs.title;
                scope.hideClose = 'block';
                scope.keyboard = true;
                scope.backdrop = true;

                if (attrs.hideclose) {
                    scope.hideClose = 'none';
                }

                if (attrs.disblebgclick) {
                    scope.keyboard = false;
                    scope.backdrop = 'static';
                }

                scope.$watch(attrs.visible, function(value) {
                    if (value == true) {
                        $(element).modal('show');
                    } else {
                        $(element).modal('hide');
                    }
                });

                $(element).on('shown.bs.modal', function() {
                    scope.$apply(function() {
                        scope.$parent[attrs.visible] = true;
                    });
                });

                $(element).on('hidden.bs.modal', function() {
                    scope.$apply(function() {
                        scope.$parent[attrs.visible] = false;
                    });
                });
            }
        };
    })
    .directive('onFinishRender', function() {
        return {
            restrict: 'A',
            link: function(scope, element, attr) {
                if (scope.$last === true) {
                    scope.$evalAsync(attr.onFinishRender);
                }
            }
        }
    })
    .directive('customPopoverThumb', function() {
        return {
            restrict: 'A',
            template: '<img src="{{label}}" style="cursor:pointer;" />',
            link: function(scope, el, attrs) {
                scope.label = attrs.popoverLabel;

                $(el).popover({
                    trigger: 'hover',
                    html: true,
                    content: attrs.popoverHtml,
                    placement: attrs.popoverPlacement
                });
            }
        };
    })
    .directive('customPopover', function() {
        return {
            restrict: 'A',
            template: '<span class="popoverLink">{{label}}</span>',
            link: function(scope, el, attrs) {
                scope.label = attrs.popoverLabel;
                $(el).popover({
                    trigger: 'click',
                    html: true,
                    content: attrs.popoverHtml,
                    placement: attrs.popoverPlacement
                });
            }
        };
    })
    .directive('scrollTo', function ($location, $anchorScroll) {
        return function (scope, element, attrs) {

            element.bind('click', function (event) {
                event.stopPropagation();
                var off = scope.$on('$locationChangeStart', function (ev) {
                    off();
                    ev.preventDefault();
                });
                var location = attrs.scrollTo;
                $location.hash(location);
                $anchorScroll();
            });

        };
    });