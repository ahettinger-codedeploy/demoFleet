(function(jQuery) {
	
	// Globals
	var g_locations = WCS3_EX1_DATA.locations,
		g_redraw_timeout = null;
	
	jQuery(document).ready(function() {
		WCS3_EX1.calculate_global_vars();
		
		redraw_classes();
	});
	
	// Handle resize
	jQuery(window).resize(function() {
		if (g_redraw_timeout != null) {
			window.clearTimeout(g_redraw_timeout);
		}
		g_redraw_timeout = window.setTimeout(function() {
			redraw_classes();
			g_redraw_timeout = null;
		}, 200);
		
	});
	
	var redraw_classes = function() {
		console.log("redrawing classes");
		jQuery('.wcs3-ex1-td-relative').remove();

		for (var i in g_locations) {
			var location = g_locations[i];
			
			if (location.layout == 'full') {
				WCS3_EX1.calculate_global_cell_height(location.location_slug);
				WCS3_EX1.draw_full_classes(location);
			}
		}
	};
	
})(jQuery);	

var WCS3_EX1 = {
	// Global object props
	g_cell_height: {},
	g_options: WCS3_EX1_DATA.options,
	g_ex_options: WCS3_EX1_DATA.ex_options,
	g_border_width: null,
	g_border_color: null,
	
	draw_full_classes: function(location) {
		var template = this.g_options.details_template;
		
		for (var x in location.classes) {
			var classes = location.classes[x],
				start_time = x;
			
			for (var y in classes) {
				var cls = classes[y],
					html,
					cell,
					cell_height,
					cell_shift,
					style = '',
					border_div,
					output = '',
					location_slug = location.location_slug;
				
				if (typeof(location_slug) != 'undefined') {
					// Create location slug
					wrapper_id = 'wcs3-location-' + location_slug;
					output = WCS3_LIB.construct_template(template, cls);
					
					cell = this.find_closest_cell(cls, wrapper_id);
					if (cell) {
						if (cls.color != null) {
							style = ' style="background-color: #' + cls.color
								+ ';"';
						}
						
						border_div = '<div class="wcs3-ex1-bottom-border"'
							+ ' style="height: ' + this.g_border_width + 'px;"></div>';
							
						html = '<div class="wcs3-ex1-td-relative">'
							+ '<div class="wcs3-class-container ' 
							+ 'wcs3-ex1-cell-wrapper ' 
							+ cell.id + '" ' + style + '>' 
							+ '<div class="wcs3-class-name">' + cls.class_title + '</div>'
							+ '<div class="wcs3-details-box-container">' + output + '</div>'
							+ border_div
							+ '</div></div>';
						
						
						
						cell.obj.append(html);
						
						cell_height = this.calculate_cell_height(cls, location.location_slug);
						jQuery('.' + cell.id).height(cell_height);
						
						cell_shift = this.calculate_cell_shift(cell, location.location_slug);
	
						if (cell_shift > 0) {
							jQuery('.' + cell.id).css('top', cell_shift + 'px');
						}
					}
				}
			}
		}
		
		// Apply bottom border div color
		jQuery('.wcs3-ex1-bottom-border').css('backgroundColor', this.g_border_color);
		
		// Apply qTip and hoverintent to .wcs3-class-container and .wcs3-qtip-box
		WCS3_LIB.apply_qtip();
	},
	
	find_closest_cell: function(cls_object, wrapper_id) {
		var start_hour_css,
			cell_class,
			cell,
			cell_id,
			match,
			hour,
			min,
			padded_min,
			shift,
			new_start_hour;
		
		start_hour_css = cls_object.start_hour_css.replace(/^0/, '');
		cell = this.get_start_cell(start_hour_css, cls_object.weekday, wrapper_id);
		
		if (cell) {
			// Got a direct match
			return {
				obj: cell,
				id: this.get_cell_id(cls_object),
				shift: 0
			}
		}
		else {
			// No direct match, we'll have to keep looking...
			// First let's separate the components
			match = start_hour_css.match(/(^\d+)-(\d+$)/);
			if (match.length > 0) {
				hour = match[1];
				min = match[2];
				shift = 0;
				
				while (min >= 0) {
					min -= 5;
					shift += 5;
					
					padded_min = WCS3_LIB.pad(min, 2)
					
					new_start_hour = hour + '-' + padded_min;
					cell = this.get_start_cell(new_start_hour, cls_object.weekday, wrapper_id);
					if (cell) {
						return {
							obj: cell,
							id: this.get_cell_id(cls_object),
							shift: parseInt(shift)
						}
					}
				}
			}
			
			return false;
		}
	},
	
	calculate_cell_height: function(cls_object, location_slug) {
		var cell_height;
				
		// Calculate height based on increments and class duration
		cell_height = (cls_object.duration / this.g_ex_options.time_increments) 
			* this.g_cell_height[location_slug];
		
		// Consider borders in height calculation
		cell_height += (cls_object.duration / this.g_ex_options.time_increments) 
			* this.g_border_width;
		
		return cell_height;
	},
	
	calculate_cell_shift: function(cell, location_slug) {
		var shift_ratio,
			shift;
		
		if (cell.shift > 0) {
			shift_ratio = this.g_ex_options.time_increments / cell.shift;
			shift = this.g_cell_height[location_slug] / shift_ratio;
			return shift;
		}
		else {
			return 0;
		}
	},

	get_start_cell: function(start_hour_css, weekday, wrapper_id) {
		var cell_class,
			cell;
		
		cell_class = '#' + wrapper_id + ' td.wcs3-hour-row-' + start_hour_css 
			+ '.wcs3-day-col-' + weekday;
	
		cell = jQuery(cell_class);
		if (cell.length > 0) {
			return cell;
		}
		else {
			return false;
		}
	},
	
	get_cell_id: function(cls_object) {
		return 'wcs3-ex1-' + cls_object.start_hour_css + '-' 
			+ cls_object.end_hour_css + '-' 
			+ cls_object.weekday;
	},
	
	calculate_global_cell_height: function(location_slug) {
		var wrapper_id = '#wcs3-location-' + location_slug + ' ';
		
		this.g_cell_height[location_slug] = jQuery(wrapper_id + '.wcs3-cell:eq(0)').height();
	},
	
	calculate_global_vars: function() {
		this.g_border_width = jQuery('.wcs3-cell:eq(0)').css('border-bottom-width');
		this.g_border_width = parseInt(this.g_border_width.replace('px', ''));
		this.g_border_color = jQuery('.wcs3-cell:eq(0)').css('border-top-color');
	},
};