    jQuery(document).ready(function() {
      jQuery("div.page_template_faq p").hide();
      jQuery("div.page_template_faq").find("p:eq(0)").show();
      jQuery("div.page_template_faq h3.faq").click(function() {
        jQuery(this).next("p").slideToggle("fast").siblings("p:visible").slideUp("fast");
      });
    });