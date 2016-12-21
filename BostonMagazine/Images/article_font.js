var article_large_font = false;

function setArticleFont(size, height) {
	$("div#article .article_content").css('font-size', size + 'px');
	$("div#article .article_content").css('line-height', height + 'px');
}

function toLargeArticleFont() {
	setArticleFont(16, 22);
}

function toNormalArticleFont() {
	setArticleFont(11, 18);
}

function updateArticleFont() {
	if (article_large_font) {
		toLargeArticleFont();
	} else {
		toNormalArticleFont();
	}
}

function toggleArticleFont() {
	article_large_font = !article_large_font;
	if (article_large_font) {
		$.cookie('article_large_font', 'large', {path: '/'});
	} else {
		$.cookie('article_large_font', 'normal', {path: '/'});
	}
	updateArticleFont();
}

function restoreArticleFont() {
	article_large_font = ($.cookie('article_large_font') == 'large');
	updateArticleFont();
}

/*
$(document).ready(restoreArticleFont);
*/

