$(document).ready(function ()
{
	$('#txtSearch').keyup(function (e)
	{
		var code = e.keyCode;
		if (code == 13)
		{
			$(".bSearch").trigger("click");
			if (e.stopPropagation)
				e.stopPropagation();
			e.cancelBubble = true;
		}
		return false;
	});
	$('#txtSearch2').keyup(function (e)
	{
		var code = e.keyCode;
		if (code == 13)
		{
			$(".bSearch2").trigger("click");
			if (e.stopPropagation)
				e.stopPropagation();
			e.cancelBubble = true;
		}
		return false;
	});

	$('.bSearch').click(function ()
	{
		if ($('#txtSearch').val() == "" || $('#txtSearch').val() == "enter keywords...")
		{
			$('#txtSearch').css("border", "solid 1px red");
		} else
		{
			$('#txtSearch').css("border", "solid 1px #680E0E");
			var searchqs = "/searchResults.aspx?q=" + $('#txtSearch').val();
			window.location = searchqs;
		}
		return false;
	});
	$('.bSearch2').click(function ()
	{
		if ($('#txtSearch2').val() == "" || $('#txtSearch2').val() == "enter keywords...")
		{
			$('#txtSearch2').css("border", "solid 1px red");
		} else
		{
			$('#txtSearch2').css("border", "solid 1px #680E0E");
			var searchqs = "/searchResults.aspx?q=" + $('#txtSearch2').val();
			window.location = searchqs;
		}
		return false;
	});


	$('.search-box').on('keyup', 'input', function (e)
	{
		var code = e.keyCode;
		if (code == 13)
		{
			$(this).next('i').trigger("click");
			if (e.stopPropagation) e.stopPropagation();
			e.cancelBubble = true;
		}
		return false;
	});

	$('.search-box').on('click', 'i', function (e)
	{
		var searchText = $(this).prev("input").val().trim();
		if (searchText == '') return;
		window.location = "/searchResults.aspx?q=" + searchText;
	});

	$('.watermark').each(function () { Watermark(this, 'enter keywords...'); });

	function Watermark(obj, txt)
	{

		if (jQuery.trim($(obj).val()) == "" || jQuery.trim($(obj).val()) == txt)
		{
			$(obj).val(txt);
			$(obj).addClass("watermark");
		}

		$(obj).focus(function ()
		{
			if ($(this).val() == txt)
			{
				$(this).val("");
			}
			$(this).removeClass("watermark");
		});

		$(obj).blur(function ()
		{
			if ($(this).val().trim() == "")
			{
				$(this).val(txt);
				$(this).addClass("watermark");
			}
		});

		return obj;
	}
});