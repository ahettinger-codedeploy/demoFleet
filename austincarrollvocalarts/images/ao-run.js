(function(){AO.core.pagesManager=new AO.views.PagesManager({el:document.body}),AO.core.pagesManager.addTopPageBannerImageEditor(),AO.modules.topMenu=new AO.views.TopMenu,AO.modules.router=new AO.router,Backbone.history.start();var t=$("#editor_left_panel_container > a.cog div");t.addClass("move"),setInterval(function(){t.toggleClass("move")},5e3)})();