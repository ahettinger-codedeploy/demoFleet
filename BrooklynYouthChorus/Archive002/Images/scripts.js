


function make_page_title(section_title,category_title,page_title,is_home) {
site_title = (category_title) ? common_page_title+' :: '+section_title+' : '+category_title+((page_title) ? ' : '+page_title : '') : common_page_title+' :: '+section_title+((page_title) ? ' : '+page_title : '');
site_title = (is_home) ? common_page_title : site_title;
document.title = site_title;
}

