+function ($) {
	'use strict';
	var toggle = '[data-toggle=dropdown]';
	var backdrop = '.dropdown-backdrop';
	var Dropdown = function(element) {
		$(element).on('click.bs.dropdown', this.toggle);
	};
	Dropdown.prototype.toggle2 = function (e) {
		var $this = $(this);

		if ($this.is('.disabled, :disabled')) return;

		var $parent = getParent($this);
		var isActive = $parent.hasClass('open');

		// BEGIN CUSTOMIZED CODE
		// Note: $this is the 'a' tag and $parent is its containing 'li'
		var hasSubMenu = $parent.children('ul').length > 0;

		// If they click again to close a menu
		if (hasSubMenu && isActive) {
			$parent.removeClass('open');
		}
		// If they click on a different top level menu, we need to close all menus
		else if (hasSubMenu && $parent.parent('ul').hasClass('navbar-nav')) {
			clearMenus(); // call their existing clear menu method
		}
		// If they are opening a sub menu, we need to close sibling sub menus
		else if ($parent.siblings('li').hasClass("open")) {
			// Need find('li') here to close all sub sub manus or they will be open when we go back to them
			$parent.parent().find('li.open').removeClass('open');
		}
		//END CUSTOMIZED CODE


		if (!isActive) {
			if ('ontouchstart' in document.documentElement && !$parent.closest('.navbar-nav').length) {
				// if mobile we use a backdrop because click events don't delegate
				$('<div class="dropdown-backdrop"/>').insertAfter($(this)).on('click', clearMenus);
			}

			var relatedTarget = { relatedTarget: this };
			$parent.trigger(e = $.Event('show.bs.dropdown', relatedTarget));

			if (e.isDefaultPrevented()) return;

			$parent
				.toggleClass('open')
				.trigger('shown.bs.dropdown', relatedTarget);

			$this.focus();
		}

		return false
	}
	function clearMenus(e) {
		$(backdrop).remove();
		$(toggle).each(function() {
			var $parent = getParent($(this));
			var relatedTarget = { relatedTarget: this };

			if (!$parent.hasClass('open')) return;

			$parent.trigger(e = $.Event('hide.bs.dropdown', relatedTarget));

			if (e.isDefaultPrevented()) return;

			$parent.removeClass('open').trigger('hidden.bs.dropdown', relatedTarget);
		});
	}

	function getParent($this) {
		var selector = $this.attr('data-target')

		if (!selector) {
			selector = $this.attr('href');
			selector = selector && /#[A-Za-z]/.test(selector) && selector.replace(/.*(?=#[^\s]*$)/, ''); //strip for ie7
		}

		var $parent = selector && $(selector);

		return $parent && $parent.length ? $parent : $this.parent();
	}

	$(document)
		.off('click.bs.dropdown.data-api', toggle, Dropdown.prototype.toggle);
	$(document)
		.on('click.bs.dropdown.data-api', toggle, Dropdown.prototype.toggle2);


	// DROPDOWN CLASS DEFINITION
	// =========================

} (jQuery);