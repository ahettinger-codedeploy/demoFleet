jQuery(document).ready(function(){jQuery(".gallery-icon a").each(function(){var e=jQuery(this).children().attr("src");var t=e.lastIndexOf("-");var n=e.lastIndexOf(".");var r=e.substring(t,n);var i=e.replace(r,"");jQuery(this).attr("rel","cyberchimps-lightbox");jQuery(this).attr("href",i)})})