/* Project Script */

var drawBackground = function () {
    var canvas = jQuery('#bg-canvas'),
        width = canvas.parent().width(),
        height = canvas.parent().height(),
        context = canvas[0].getContext('2d'),
        color1 = 'rgba(255, 255, 255, 0.25)',
        color2 = 'rgba(255, 255, 255, 0.41)',
        color3 = 'rgba(255, 255, 255, 0.41)',
        originX,
        originY;

    // Resize canvas
    canvas[0].width = width;
    canvas[0].height = height;

    // Draw pane background
    if (jQuery('#content.bg-design-rect').length) {
        if (jQuery('#content.page-default').length) {
            context.fillStyle = color1;
            context.fillRect(width * 0.05, 0, width * 0.45, height);
            context.fillStyle = color2;
            context.fillRect(width * 0.05, 199, width * 0.45, height - 199);
            context.fillStyle = color3;
            context.fillRect(width * 0.09, 230, width * 0.37, height - 261);
        } else if (jQuery('#content.page-fullwidth').length) {
            context.fillStyle = color1;
            context.fillRect(width * 0.05, 0, width * 0.9, height);
            context.fillStyle = color2;
            context.fillRect(width * 0.05, 199, width * 0.9, height - 199);
            context.fillStyle = color3;
            context.fillRect(width * 0.09, 230, width * 0.82, height - 261);
        }
    } else if (jQuery('#content.bg-design-ring').length) {
        originX = width * 0.55 / 2;
        originY = height * 2 / 3;
        context.beginPath();
        context.arc(originX, originY, width * 0.55 / 2 * 0.95, 0, 2 * Math.PI, false);
        context.fillStyle = color1;
        context.fill();
        context.closePath();
        context.beginPath();
        context.arc(originX, originY, width * 0.55 / 2 * 0.8, 0, 2 * Math.PI, false);
        context.fillStyle = color2;
        context.fill();
        context.closePath();
        context.beginPath();
        context.arc(originX, originY, width * 0.55 / 2 * 0.65, 0, 2 * Math.PI, false);
        context.fillStyle = color3;
        context.fill();
        context.closePath();
    }
};

drawBackground();
jQuery(window).bind('load resize', drawBackground);
