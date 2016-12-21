/**
 * Super Simple Fancy Checkbox Plugin 
 * @Dave Macaulay, 2013
 */
(function ($) {
    $.fn.simpleCheckbox = function(options) {
        var defaults = {
            newElementClass: 'switch-toggle',
            activeElementClass: 'switch-on'
        };
        var options = $.extend(defaults, options);
        this.each(function() {
            //Assign the current checkbox to obj
            var obj = $(this);
            var objId = obj.attr('id');

            //Create new span element to be styled
            var newObj = $('<div/>', {
                'id': 'sw_' + objId,
                'class': options.newElementClass,
                'style': 'display: block;'
            }).insertAfter(this);

            //Make sure pre-checked boxes are rendered as checked
            if(obj.is(':checked')) {
                newObj.addClass(options.activeElementClass);
            }
            obj.hide(); //Hide original checkbox


            //Labels can be painful, let's fix that
            if ($('[for=' + objId + ']').length) {

                var label = $('[for=' + objId + ']');
                label.click(function() {
                    newObj.trigger('click'); //Force the label to fire our element
                    return false;
                });
            }

            //Attach a click handler
            newObj.click(function() {
                //Assign current clicked object
                //johnny edit
                var nobj = $(this);
                //Check the current state of the checkbox
                if (nobj.hasClass(options.activeElementClass)) {
                    nobj.removeClass(options.activeElementClass);
                    $(nobj.attr('id')).attr('checked', false);
                    //obj.prop('checked', false);
                    //johnny edit
                    obj.trigger('click');
                } else {
                    nobj.addClass(options.activeElementClass);
                    $(nobj.attr('id')).attr('checked', true);
                    //obj.prop('checked', true);
                    //johnny edit
                    obj.trigger('click');
                }
                //Kill the click function
                return false;
            });
        });
    };
})(jQuery);