jQuery.fn.center = function () {
	this.css("position", "absolute");
	this.css("top", (($(window).height() - this.outerHeight()) / 2) + $(window).scrollTop() + "px");
	this.css("left", (($(window).width() - this.outerWidth()) / 2) + $(window).scrollLeft() + "px");
	return this;
}

$(function () {
	PopulateFavoritesList();

	SetFavoriteIcon();

	// Handle Event Bubbling
	$('html').click(function () {
		//Hide the menus if visible
		$('#favoritesList').slideUp('fast');
		$('#favoritesList').removeClass('open');
	});

	$('.commonToolbar').click(function (event) {
		event.stopPropagation();
	});

	// Event: Close Modal
	$('.modalContainer.editFavorite a.modalClose').click(function () {
		CloseFavoriteModal();
	})

	// Event: Save
	$('.modalContainer.editFavorite .save').live('click', function () {
		var $modal = $('.modalContainer.editFavorite');
		var id = $('.modalContent #ID').val();
		var name = $('.modalContent #Name').val();
		var link = $('.modalContent #Link').val();

		if (name == "" || link == "") {
			alert($('#Localization_SaveInvalid').html());
			return;
		}

		$.ajaxSetup({ cache: false });
		$.post('/myaccount/favorites/save', { Id: id, Name: name, Link: link }, function (data) {
			PopulateFavoritesList(data);
			SetFavoriteIcon();
			CloseFavoriteModal();
		});
		$.ajaxSetup({ cache: true });
	});

	// Event: Cancel
	$('.modalContainer.editFavorite .cancel').live('click', function () {
		CloseFavoriteModal();
	});

	// Event: Remove from favorites
	$('.modalContainer.editFavorite .delete').live('click', function () {
		var id = $('.modalContent #ID').val();
		DeleteFavorite(id);
		CloseFavoriteModal();

	});

	// Event: Little star button used to favorite stuff.
	$('.commonToolbar .inner .button.add').click(function () {

		$.ajaxSetup({ cache: false });
		$.post('/myaccount/favorites/isfavorited', { url: window.location.href }, function (data) {
			if (data.favorited) {
				SaveFavoriteModal($('#Localization_EditTitle').html(), data.ID, data.Name, data.Link, true);
				SetFavoriteIcon();
				return;
			}

			var $modal = $('.modalContainer.editFavorite');
			if ($modal.hasClass('hidden') || $modal.css('display') == 'none')
				SaveFavoriteModal($('#Localization_SaveTitle').html(), 0);
			else
				$modal.fadeOut('fast');

			var $img = $(this).find('img'),
					src = $img.attr('src');
			if ($modal.hasClass('hidden') || $modal.css('display') == 'none') {
				$img.attr('src', '/Common/Images/MyAccount/HomeAddFavoriteIcon.png');
			} else {
				$img.attr('src', '/Common/Images/MyAccount/HomeAddedFavoriteIcon.png');
			}
		});
		$.ajaxSetup({ cache: true });
	});

	UpdateBindings();
	//(".modalContainer.manageFavorites").draggable();
});

function UpdateBindings() {

	$('.commonToolbar .inner .addFavorite').click(function () {

		$.ajaxSetup({ cache: false });
		$.post('/myaccount/favorites/isfavorited', { url: window.location.href }, function (data) {
			if (data.favorited) {
				SaveFavoriteModal($('#Localization_EditTitle').html(), data.ID, data.Name, data.Link, true);
				SetFavoriteIcon();
				return;
			}

			var $modal = $('.modalContainer.editFavorite');
			if ($modal.hasClass('hidden') || $modal.css('display') == 'none')
				SaveFavoriteModal($('#Localization_SaveTitle').html(), 0);
			else
				$modal.fadeOut('fast');

			var $img = $(this).find('img'),
					src = $img.attr('src');
			if ($modal.hasClass('hidden') || $modal.css('display') == 'none') {
				$img.attr('src', '/Common/Images/MyAccount/HomeAddFavoriteIcon.png');
			} else {
				$img.attr('src', '/Common/Images/MyAccount/HomeAddedFavoriteIcon.png');
			}
		});
		$.ajaxSetup({ cache: true });
	});

	// Event: Edit Favorite 
	$('#favoritesList ul li .edit').click(function () {
		var id = $(this).parent().children('.id').html();
		var name = $(this).parent().children('.name').html();
		var link = $(this).parent().children('.link').html();

		SaveFavoriteModal($('#Localization_EditTitle').html(), id, name, link, true);
	});
	SetFavoriteIcon();
}

function SetFavoriteIcon() {
	$img = $('.commonToolbar .inner .button.add').find('img');
	if ($img.length > 0)
		$.ajaxSetup({ cache: false });
		$.post('/myaccount/favorites/isfavorited', { url: window.location.href }, function (data) {
			if (data.favorited == 0) {
				$img.attr('src', '/Common/Images/MyAccount/HomeAddFavoriteIcon.png');
			} else {
				$img.attr('src', '/Common/Images/MyAccount/HomeAddedFavoriteIcon.png');
			}	
		});
		$.ajaxSetup({ cache: true });
	}


function CloseFavoriteModal() {
	var $modal = $('.modalContainer.editFavorite');
	$modal.fadeOut('fast');
	//$modal.addClass('hidden');
}

function SaveFavoriteModal(title,id, name, link,edit) {
	// popup modal
	var $modal = $('.modalContainer.editFavorite');
	$modal.children('.modalTitleLeft').children('.modalTitle').html(title);

	$.ajaxSetup({ cache: false });
	$('.modalContainer.editFavorite .modalContent').load('/myaccount/favorites/saveform', function () {
		if ($modal.children('.modalTitleLeft').children('.modalTitle').html() == "")
			$modal.children('.modalTitleLeft').children('.modalTitle').html($('#Localization_SaveTitle').html());

		// fill out modal fields
		$('.modalContent #ID').val(id);
		$('.modalContent #Name').val(name);
		$('.modalContent #Link').val(link);

		// if link is not supplied use the current url
		if ($('.modalContent #Link').val() == "")
			$('.modalContent #Link').val(window.location.href);

		// if name is not supplied try using the page title.
		if ($('.modalContent #Name').val() == "") {
			$('.modalContent #Name').val($('#pageTitle').val());
		} 

		// if name is still nothing try using the URL resource
		if ($('.modalContent #Name').val() == "") {
			var components = window.location.href.split('?');
			var base = components[0];
			var last = base.split('/');
			last = last[last.length - 1];
			var nameAlone = CapitalizeFirstLetter(last.split('.')[0]);
			nameAlone = nameAlone.split('#')[0];						// Take care of trailing # signs and variables
			$('.modalContent #Name').val(nameAlone);
		}

		// if it's still blank then use Home
		if ($('.modalContent #Name').val() == "") {
			$('.modalContent #Name').val("Home");
		} 


		// if not editing a entry don't show the remove from favorites option
		if (edit != true)
			$('.modalContainer.editFavorite .delete').addClass('hidden');

		// If title is empty use default localization.
		if (title == "" || title === undefined || title == null) {
			if (edit)
				$modal.children('.modalTitleLeft').children('.modalTitle').html($('#Localization_EditTitle').html());
			else
				$modal.children('.modalTitleLeft').children('.modalTitle').html($('#Localization_SaveTitle').html());
		}
		// If editing we need to change the dialog title to the editing dialog localized text.
		$modal.center();
		$modal.fadeIn('fast', function () { $modal.removeClass('hidden'); });

	});
	$.ajaxSetup({ cache: true });
}
function CapitalizeFirstLetter(string) {
	return string.charAt(0).toUpperCase() + string.slice(1);
}

function SaveFavorite(id, name,link){
	$.ajaxSetup({ cache: false });
	$.post('/myaccount/favorites/save/' + id);
	$.ajaxSetup({ cache: true });
}
function DeleteFavorite(id) {
	$.ajaxSetup({ cache: false });
	$.post('/myaccount/favorites/delete/' + id, function (data) {
		PopulateFavoritesList(data);
	});
	$.ajaxSetup({ cache: true });
}
function PopulateFavoritesList(data) {
	if (data === undefined) {
		$.ajaxSetup({ cache: false });
		$('.favoritesList').load('/myaccount/favorites/list', function () { UpdateBindings(); });
		$.ajaxSetup({ cache: true });
	}
	else {
		$('.favoritesList').html(data);
		UpdateBindings();
	}
	SetFavoriteIcon();
}