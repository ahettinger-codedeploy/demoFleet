(function(){AO.views.pages.News=Backbone.View.extend({initialize:function(){this.$el.find(".tab-pane.active").addClass("pag").pajinate({items_per_page:4,show_paginate_if_one:!1}),this.$el.find('a[data-toggle="tab"]').on("shown.bs.tab",function(e){$($(e.target).attr("href")).hasClass("pag")||$($(e.target).attr("href")).addClass("pag").pajinate({items_per_page:4,show_paginate_if_one:!1})}),this.nav_tabs=this.$el.find(".nav-tabs"),this.nav_tabs.find("li:last > a").trigger("click")}})})();